FROM odoo:19

# Switch to root to install system dependencies
USER root

# Install additional system packages if needed
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        libldap2-dev \
        libsasl2-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy custom Python requirements (if any)
COPY requirements.txt /tmp/requirements.txt
RUN grep -v '^\s*#' /tmp/requirements.txt | grep -q . \
    && pip3 install --no-cache-dir -r /tmp/requirements.txt \
    || echo "No extra Python requirements to install"

# Copy custom addons
COPY addons /mnt/extra-addons

# Fix permissions
RUN chown -R odoo:odoo /mnt/extra-addons

# Back to odoo user
USER odoo

EXPOSE 8069 8072
