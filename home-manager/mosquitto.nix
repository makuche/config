# { config, pkgs, ... }:
#
# {
#   # NOTE: Its assumed that mosquitto is already installed
#   services.mosquitto = {
#     enable = true;
#     listeners = [
#       {
#         port = 1883;
#         users = {
#           myuser = {
#             password = "mypassword";
#             acl = [ "topic readwrite #" ];
#           };
#         };
#       }
#     ];
#   };
#
#   systemd.user.services.mosquitto = {
#     Unit = {
#       Description = "Mosquitto MQTT Broker";
#       After = [ "network.target" ];
#     };
#     Service = {
#       ExecStart = "${pkgs.mosquitto}/bin/mosquitto -c %h/.config/mosquitto/mosquitto.conf";
#       Restart = "on-failure";
#     };
#     Install = {
#       WantedBy = [ "default.target" ];
#     };
#   };
#
#   home.file.".local/bin/start-mosquitto.sh" = {
#     text = ''
#       #!/bin/sh
#       mosquitto -c $HOME/.config/mosquitto/mosquitto.conf
#     '';
#     executable = true;
#   };
# }
