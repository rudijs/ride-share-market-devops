default["rabbitmq"]["job_control"] = "upstart"

default["rabbitmq"]["disabled_users"] = ["guest"]

default["rabbitmq"]["virtualhosts"] = ["rsm"]

# default["rabbitmq"]["enabled_users"] = [
#     {
#         "name" => "admin",
#         "password" => "abcdef",
#         "tag" => "administrator",
#         "rights" => [
#             {
#                 "vhost" => "/",
#                 "conf" => ".*",
#                 "read" => ".*",
#                 "write" => ".*"
#             },
#             {
#                 "vhost" => "rsm",
#                 "conf" => ".*",
#                 "read" => ".*",
#                 "write" => ".*"
#             }
#         ]
#     },
#     {
#         "name" => "rsm",
#         "password" => "abc123",
#         "rights" => [
#             {
#                 "vhost" => "rsm",
#                 "conf" => ".*",
#                 "read" => ".*",
#                 "write" => ".*"
#             }
#         ]
#     }
# ]
