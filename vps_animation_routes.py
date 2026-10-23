"""Flask blueprint for NRB VPS installation animation; reads saved DB progress only."""
import json, time
from flask import Blueprint, Response, abort, render_template, request, session, stream_with_context
import nrb_database

vps_animation_bp = Blueprint('vps_animation', __name__)

def current_user_id():
    # Adjust this to match the existing NRB login/session implementation.
    return session.get('user_id') or session.get('user') or session.get('username')

@vps_animation_bp.get('/vps/installation')
def installation_page():
    uid = current_user_id()
    if not uid:
        abort(401)
    job_id = request.args.get('job_id', '').strip()
    if not job_id or not nrb_database.get_installation(job_id, uid):
        abort(404, description='Installation job not found for this account')
    return render_template('vps_creation_animation.html')

@vps_animation_bp.get('/api/vps/install-progress/<job_id>')
def install_progress(job_id):
    uid = current_user_id()
    if not uid:
        abort(401)
    @stream_with_context
    def stream():
        previous = None
        while True:
            job = nrb_database.get_installation(job_id, uid)
            if not job:
                yield 'event: progress\ndata: ' + json.dumps({'status':'failed','error':'Installation job not found'}) + '\n\n'
                return
            payload = {'status':job['status'], 'step':job.get('current_step') or 'dependencies',
              'progress':int(job.get('progress') or 0),
              'message':job.get('error_message') or ('VPS is ready' if job['status']=='completed' else 'Installing your VPS…'),
              'error':job.get('error_message'),
              'vps':{'name':job.get('vps_name'),'cpu':job.get('cpu'),
                'memory':f"{job.get('memory_mb', 0)} MB",'storage':f"{job.get('storage_gb', 0)} GB",
                'os':job.get('os_image','ubuntu'),'private_ip':job.get('private_ip')}}
            data = json.dumps(payload, separators=(',',':'))
            if data != previous:
                yield 'event: progress\ndata: ' + data + '\n\n'
                previous = data
            if job['status'] in ('completed','failed'):
                return
            yield ': keep-alive\n\n'
            time.sleep(1.5)
    return Response(stream(), mimetype='text/event-stream', headers={'Cache-Control':'no-cache','X-Accel-Buffering':'no'})
