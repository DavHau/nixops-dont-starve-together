{pkgs, ...}:
{
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    vim htop git
    docker-compose
  ];
  deployment.keys = {
    cluster-token = {
      keyFile = ./keys/cluster-token.txt;
      destDir = "/keys";
    };
  };
  swapDevices = [{
    size = 4096;
    device = "/tmp/swapfile";
  }];
  systemd.services.dst = {
    wantedBy = [ "multi-user.target" ];
    after = [ "ntwork-online.target" ];
    path = with pkgs; [ git docker-compose];
    script = ''
      if [ ! -e /root/dst-dedicated-server ]; then
        mkdir -p /root/
        cd /root
        git clone https://github.com/mathielo/dst-dedicated-server
        chown -R 1000.1000 /root/dst-dedicated-server
      fi
      cd /root/dst-dedicated-server
      cat /keys/cluster-token > ./DSTClusterConfig/cluster_token.txt
      cat ${./config/cluster.ini} > ./DSTClusterConfig/cluster.ini
      cat ${./config/dedicated_server_mods_setup.lua} > ./DSTClusterConfig/mods/dedicated_server_mods_setup.lua
      cat ${./config/modoverrides.lua} > ./DSTClusterConfig/mods/modoverrides.lua
      docker-compose down
      docker-compose up -d
    '';
  };
  networking.firewall.allowedUDPPorts = [ 10998 10999 ];
}