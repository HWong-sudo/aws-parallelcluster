#!/bin/bash
set -ex
. "/etc/parallelcluster/cfnconfig"


if [[ $cfn_node_type == "HeadNode" ]]; then
    # Override run_instance attributes
    cat > /opt/slurm/etc/pcluster/run_instances_overrides.json << 'EOF'
{
    "q1": {
        "efa-enabled": {
            "CapacityReservationSpecification": {
                "CapacityReservationTarget": {
                    "CapacityReservationId": "cr-0fa65fcdbd597f551"
                }
            }
        }
    }
}
EOF
fi