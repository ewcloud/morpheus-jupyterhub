# from https://github.com/jupyterhub/jupyterhub/wiki/Run-jupyterhub-as-a-system-service

cp jupyterhub /etc/init.d/
chmod +x /etc/init.d/jupyterhub
# Create a default config to /etc/jupyterhub/jupyterhub_config.py
mkdir -p /etc/jupyterhub
jupyterhub --generate-config -f /etc/jupyterhub/jupyterhub_config.py
# enable jupyterhub to listen on 0.0.0.0:80
echo "c.JupyterHub.hub_ip = ''" >> /etc/jupyterhub/jupyterhub_config.py
echo "c.JupyterHub.port = 80" >> /etc/jupyterhub/jupyterhub_config.py
# Reload systemctl daemon to notice the init.d script
systemctl daemon-reload
# Start jupyterhub
service jupyterhub start
# Stop jupyterhub
#service jupyterhub stop
# Start jupyterhub on boot
update-rc.d jupyterhub defaults