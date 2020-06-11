def prometheus_targets_for_grain(key):
    values = __salt__['mine.get']('*', 'grains.items', tgt_type='glob').values()
    return [ remote_grains[key] for remote_grains in values if key in remote_grains ]
