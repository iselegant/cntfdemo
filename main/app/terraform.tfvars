# ---------------------------------
#  Scope: local
# ---------------------------------
lb_priority               = 1
ecs_service_desired_count = 2
ecs_task_cpu              = "512"
ecs_task_memory           = "1024"
ecs_container_cpu         = "256"
ecs_container_memory      = "512"
as_min_capacity           = "2"
as_max_capacity           = "4"