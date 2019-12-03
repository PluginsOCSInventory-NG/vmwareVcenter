###############################################################################
## OCSINVENTORY-NG
## Copyleft Gilles Dubois 2017
## Web : http://www.ocsinventory-ng.org
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
################################################################################

package Ocsinventory::Agent::Modules::Vmware;

# Use
use LWP::UserAgent;
use JSON;

# Auth
my @auth_hashes = (
    {
       URL  => "MY_FIRST_VMWARE_SERVER",
       AUTH_DIG     => "My Auth digest (user + pass encoded in base 64)",
    },
    {
       URL => "MY_SECOND_VMWARE_SERVER",
       AUTH_DIG    => "My Auth digest (user + pass encoded in base 64)",
    },
  );

# Configuration
my $server_url = "";
my $session_id = "";
my $auth_digest = "";
my $auth_return;
my $api_filter;

# sub routines var
my $server_endpoint;
my $restpath;
my $auth_dig;
my $lwp_useragent;
my $resp;
my $req;
my $message;

# current contexte
my $current_datacenter;
my $current_cluster;
my $current_host;
my $current_resource_pool;
my $current_vm;

# Replacement strings
my $vm_string = "{vmid}";
my $details_string = "{details}";

# VmWare references api hash
my %vmware_api_references = (
    "vmware_login" => "rest/com/vmware/cis/session",
    "vmware_datacenter" =>  "rest/vcenter/datacenter",
    "vmware_datacenter_details" =>  "rest/vcenter/datacenter/{details}",
    "vmware_resourcepool" =>  "rest/vcenter/resource-pool",
    "vmware_resourcepool_details" =>  "rest/vcenter/resource-pool/{details}",
    "vmware_cluster" =>  "rest/vcenter/cluster",
    "vmware_cluster_details" =>  "rest/vcenter/cluster/{details}",
    "vmware_host" =>  "rest/vcenter/host",
    "vmware_datastore" => "rest/vcenter/datastore",
    "vmware_datastore_details" => "rest/vcenter/datastore/{details}",
    "vmware_folder" =>  "rest/vcenter/folder",
    "vmware_networks" =>  "rest/vcenter/network",
    "vmware_system_version" => "appliance/system/version",
    "vmware_system_uptime" => "appliance/system/uptime",
    "vmware_vm" =>  "rest/vcenter/vm",
    "vmware_vm_details" =>  "rest/vcenter/vm/{vmid}",
);

sub new {

   my $name="vmware";   # Name of the module

   my (undef,$context) = @_;
   my $self = {};

   #Create a special logger for the module
   $self->{logger} = new Ocsinventory::Logger ({
            config => $context->{config}
   });

   $self->{logger}->{header}="[$name]";

   $self->{context}=$context;

   $self->{structure}= {
                        name => $name,
                        start_handler => undef,    #or undef if don't use this hook
                        prolog_writer => undef,    #or undef if don't use this hook
                        prolog_reader => undef,    #or undef if don't use this hook
                        inventory_handler => $name."_inventory_handler",    #or undef if don't use this hook
                        end_handler => undef    #or undef if don't use this hook
   };

   bless $self;
}

######### Hook methods ############

sub vmware_inventory_handler {

   my $self = shift;
   my $logger = $self->{logger};

   my $common = $self->{context}->{common};

   # Debug log for inventory
   $logger->debug("Starting VMWare inventory plugin");

   foreach (@auth_hashes){

       $server_url = $_->{'URL'};
       $auth_digest = $_->{'AUTH_DIG'};

       # Auth to VMWare
       $auth_return = send_auth_api_query($server_url, $vmware_api_references{"vmware_login"}, $auth_digest);
       if (exists $auth_return->{'value'}){

         $session_id = $auth_return->{'value'};

         # Auth OK
         $logger->debug("Auth OK");

         # Set api fitler to nothing
         $api_filter = "";

         # Datacenter infos
         my $datacenter_infos = send_api_query($server_url, $vmware_api_references{"vmware_datacenter"}, $session_id, "", $logger);
         foreach (@{$datacenter_infos->{'value'}}){

           # Process datacenter infos
           $logger->debug("Process info for datacenter : ".$_->{'datacenter'});

           # Get Datacenter details
           my $datacenter_details = send_api_query($server_url, replace_string_to($vmware_api_references{"vmware_datacenter_details"}, $details_string, $_->{'datacenter'}), $session_id, "", $logger);

           # Add XML
           push @{$common->{xmltags}->{VMWARE_DATACENTER}},
           {
              HOST_FOLDER => [$datacenter_details->{'value'}->{'host_folder'}],
              NETWORK_FOLDER => [$datacenter_details->{'value'}->{'network_folder'}],
              VM_FOLDER => [$datacenter_details->{'value'}->{'vm_folder'}],
              NAME => [$datacenter_details->{'value'}->{'name'}],
              DATASTORE_FOLDER => [$datacenter_details->{'value'}->{'datastore_folder'}],
           };

           # Set current datacenter
           $current_datacenter = $_->{'datacenter'};

           # Get cluster affiliated to the datacenter
           $api_filter = "?filter.datacenters=" . $_->{'datacenter'};

           # Get datastore for this datacenter
           my $datastore_infos = send_api_query($server_url, $vmware_api_references{"vmware_datastore"}, $session_id, $api_filter, $logger);
           foreach (@{$datastore_infos->{'value'}}){
             # Get datastore details
             my $datastore_details = send_api_query($server_url, replace_string_to($vmware_api_references{"vmware_datastore_details"}, $details_string, $_->{'datastore'}), $session_id, "", $logger);

             # add xml
             push @{$common->{xmltags}->{VMWARE_DATASTORE}},
             {
                DATACENTER => [$current_datacenter],
                IS_ACCESSIBLE => [manage_json_pp_bool($datastore_details->{'value'}->{'accessible'})],
                NAME => [$datastore_details->{'value'}->{'name'}],
                DATASTORE => [$_->{'datastore'}],
                MULTIPLE_HOST_ACCESS => [manage_json_pp_bool($datastore_details->{'value'}->{'multiple_host_access'})],
                CAPACITY => [$_->{'capacity'}],
                FREE_SPACE => [$_->{'free_space'}],
                THIN_PROVISIONING_SUPPORTED => [manage_json_pp_bool($datastore_details->{'value'}->{'thin_provisioning_supported'})],
                TYPE => [$_->{'type'}],
             };

           }

           # Get networks for this datacenter
           my $networks_infos = send_api_query($server_url, $vmware_api_references{"vmware_networks"}, $session_id, $api_filter, $logger);
           foreach (@{$networks_infos->{'value'}}){
             # add xml
             push @{$common->{xmltags}->{VMWARE_NETWORK}},
             {
                DATACENTER => [$current_datacenter],
                NETWORK => [$_->{'network'}],
                NAME => [$_->{'name'}],
                TYPE => [$_->{'type'}],
             };
           }

           # Get folders for this datacenter
           my $folders_infos = send_api_query($server_url, $vmware_api_references{"vmware_folder"}, $session_id, $api_filter, $logger);
           foreach (@{$folders_infos->{'value'}}){
             # add xml
             push @{$common->{xmltags}->{VMWARE_FOLDER}},
             {
                DATACENTER => [$current_datacenter],
                FOLDER => [$_->{'folder'}],
                NAME => [$_->{'name'}],
                TYPE => [$_->{'type'}],
             };
           }

           my $clusters_infos = send_api_query($server_url, $vmware_api_references{"vmware_cluster"}, $session_id, $api_filter, $logger);
             foreach (@{$clusters_infos->{'value'}}){

                 # Process cluster infos
                 $logger->debug("Process info for cluster : ".$_->{'cluster'});

                 # Get cluster details
                 my $clusters_details = send_api_query($server_url, replace_string_to($vmware_api_references{"vmware_cluster_details"}, $details_string, $_->{'cluster'}), $session_id, $api_filter, $logger);

                 # add xml
                 push @{$common->{xmltags}->{VMWARE_CLUSTER}},
                 {
                    DATACENTER => [$current_datacenter],
                    DRS_ENABLED => [manage_json_pp_bool($_->{'drs_enabled'})],
                    HA_ENABLED => [manage_json_pp_bool($_->{'ha_enabled'})],
                    NAME => [$_->{'name'}],
                    CLUSTER => [$_->{'cluster'}],
                 };

                 # Set current cluster
                 $current_cluster = $_->{'cluster'};

                 # Set filter for cluster and datacenter
                 $api_filter = "?filter.datacenters=".$current_datacenter."&filter.clusters=".$current_cluster;

                 # Get Hosts with in this datacenter and cluster
                 my $hosts_infos = send_api_query($server_url, $vmware_api_references{"vmware_host"}, $session_id, $api_filter, $logger);
                 foreach (@{$hosts_infos->{'value'}}){

                   # Set current host
                   $current_host = $_->{'host'};

                   # Set filter for cluster / datacenter and host itself
                   $api_filter = "?filter.datacenters=".$current_datacenter."&filter.clusters=".$current_cluster."&filter.hosts=".$current_host;

                   # Get ressources pool for this cluster and host
                   my $resources_pool_infos = send_api_query($server_url, $vmware_api_references{"vmware_resourcepool"}, $session_id, $api_filter, $logger);

                   foreach (@{$resources_pool_infos->{'value'}}){

                     # add xml
                     push @{$common->{xmltags}->{VMWARE_RESOURCEPOOL}},
                     {
                        DATACENTER => [$current_datacenter],
                        CLUSTER => [$current_cluster],
                        HOST => [$current_host],
                        RESOURCE_POOL => [$_->{'resource_pool'}],
                        NAME => [$_->{'name'}],
                     };

                     # set current resource pool
                     $current_resource_pool = $_->{'resource_pool'};

                     # Set filter for resource pool
                     $api_filter = "?filter.datacenters=".$current_datacenter."&filter.clusters=".$current_cluster."&filter.hosts=".$current_host."&filter.resource_pools=".$current_resource_pool;

                     # Used filter for query
                     $logger->debug("Used query filter : ".$api_filter);

                     # Get vm by host and resource pool
                     my $vm_infos = send_api_query($server_url, $vmware_api_references{"vmware_vm"}, $session_id, $api_filter, $logger);

                     foreach(@{$vm_infos->{'value'}}){

                         # Process VM infos
                         $logger->debug("Process info for VM : ".$_->{'vm'});

                         # Set current vm id
                         $current_vm = $_->{'vm'};

                         # Get VM Basics informations
                         my $vm_infos_details = send_api_query($server_url, replace_string_to($vmware_api_references{"vmware_vm_details"}, $vm_string, $_->{'vm'}), $session_id, "", $logger);

                         # add xml for common infos
                         push @{$common->{xmltags}->{VMWARE_VM}},
                         {
                            DATACENTER => [$current_datacenter],
                            CLUSTER => [$current_cluster],
                            HOST => [$current_host],
                            RESOURCE_POOL => [$current_resource_pool],
                            VM => [$current_vm],
                            CPU_COUNT => [$_->{'cpu_count'}],
                            POWER_STATE => [$_->{'power_state'}],
                            NAME => [$_->{'name'}],
                            MEMORY_SIZE_MIB => [$_->{'memory_size_MiB'}],
                            GUEST_OS => [$vm_infos_details->{'value'}->{'guest_OS'}],
                         };

                         # add xml for boot informations
                         push @{$common->{xmltags}->{VMWARE_VM_BOOT}},
                         {
                            VM => [$current_vm],
                            ENTER_SETUP_MODE => [manage_json_pp_bool($vm_infos_details->{'value'}->{'boot'}->{'enter_setup_mode'})],
                            RETRY => [manage_json_pp_bool($vm_infos_details->{'value'}->{'boot'}->{'retry'})],
                            EFI_LEGACY_BOOT => [manage_json_pp_bool($vm_infos_details->{'value'}->{'boot'}->{'efi_legacy_boot'})],
                            NETWORK_PROTOCOL => [$vm_infos_details->{'value'}->{'boot'}->{'network_protocol'}],
                            DELAY => [$vm_infos_details->{'value'}->{'boot'}->{'delay'}],
                            RETRY_DELAY => [$vm_infos_details->{'value'}->{'boot'}->{'retry_delay'}],
                            TYPE => [$vm_infos_details->{'value'}->{'boot'}->{'type'}],
                         };

                         # add xml for boot informations
                         push @{$common->{xmltags}->{VMWARE_VM_HARDWARE}},
                         {
                            VM => [$current_vm],
                            VERSION => [$vm_infos_details->{'value'}->{'hardware'}->{'version'}],
                            UPGRADE_STATUS => [$vm_infos_details->{'value'}->{'hardware'}->{'upgrade_status'}],
                            UPGRADE_VERSION => [$vm_infos_details->{'value'}->{'hardware'}->{'upgrade_version'}],
                            UPGRADE_POLICY => [$vm_infos_details->{'value'}->{'hardware'}->{'upgrade_policy'}]
                         };

                         # add xml for cpu informations
                         push @{$common->{xmltags}->{VMWARE_VM_CPU}},
                         {
                            VM => [$current_vm],
                            COUNT => [$vm_infos_details->{'value'}->{'cpu'}->{'count'}],
                            HOT_ADD_ENABLED => [manage_json_pp_bool($vm_infos_details->{'value'}->{'cpu'}->{'hot_add_enabled'})],
                            HOT_REMOVE_ENABLED => [manage_json_pp_bool($vm_infos_details->{'value'}->{'cpu'}->{'hot_remove_enabled'})],
                            CORES_PER_SOCKET => [$vm_infos_details->{'value'}->{'cpu'}->{'cores_per_socket'}]
                         };

                         # add xml for memory informations
                         push @{$common->{xmltags}->{VMWARE_VM_MEMORY}},
                         {
                            VM => [$current_vm],
                            HOT_ADD_INCREMENT_SIZE => [manage_json_pp_bool($vm_infos_details->{'value'}->{'memory'}->{'hot_add_increment_size_MiB'})],
                            HOT_ADD_ENABLED => [manage_json_pp_bool($vm_infos_details->{'value'}->{'memory'}->{'hot_add_enabled'})],
                            HOT_ADD_LIMIT_MIB => [$vm_infos_details->{'value'}->{'memory'}->{'hot_add_limit_MiB'}],
                            SIZE_MIB => [$vm_infos_details->{'value'}->{'memory'}->{'size_MiB'}]
                         };

                         foreach(@{$vm_infos_details->{'value'}->{'nics'}}){
                           # add xml for networks interface
                           push @{$common->{xmltags}->{VMWARE_VM_NETINTERFACE}},
                           {
                              VM => [$current_vm],
                              KEY_REF => [$_->{'key'}],
                              WAKE_ON_LAN_ENABLED => [manage_json_pp_bool($_->{'value'}->{'wake_on_lan_enabled'})],
                              START_CONNECTED => [manage_json_pp_bool($_->{'value'}->{'start_connected'})],
                              STATE => [$_->{'value'}->{'state'}],
                              MAC_TYPE => [$_->{'value'}->{'mac_type'}],
                              MAC_ADDRESS => [$_->{'value'}->{'mac_address'}],
                              UPT_COMPATIBILITY_ENABLED => [manage_json_pp_bool($_->{'value'}->{'upt_compatibility_enabled'})],
                              PCI_SLOT_NUMBER => [$_->{'value'}->{'pci_slot_number'}],
                              LABEL => [$_->{'value'}->{'label'}],
                              TYPE => [$_->{'value'}->{'type'}],
                              BACKING_DISTRIBUTED_SWITCH_UUID => [$_->{'value'}->{'backing'}->{'distributed_switch_uuid'}],
                              BACKING_DISTRIBUTED_PORT => [$_->{'value'}->{'backing'}->{'distributed_port'}],
                              BACKING_NETWORK => [$_->{'value'}->{'backing'}->{'network'}],
                           };

                         }

                         foreach(@{$vm_infos_details->{'value'}->{'disks'}}){
                           # add xml for networks interface
                           push @{$common->{xmltags}->{VMWARE_VM_DISK}},
                           {
                              VM => [$current_vm],
                              KEY_REF => [$_->{'key'}],
                              BACKING_TYPE => [$_->{'value'}->{'backing'}->{'type'}],
                              BACKING_VMDK_FILE => [$_->{'value'}->{'backing'}->{'vmdk_file'}],
                              LABEL => [$_->{'value'}->{'label'}],
                              TYPE => [$_->{'value'}->{'type'}],
                              CAPACITY => [$_->{'value'}->{'capacity'}],
                              SCSI_UNIT => [$_->{'value'}->{'scsi'}->{'unit'}],
                              SCSI_BUS => [$_->{'value'}->{'scsi'}->{'bus'}],
                            };

                         }

                     }

                     undef $vm_infos;

                   }

                   undef $resources_pool_infos;

                 }

                 undef $hosts_infos;

             }

             undef $clusters_infos;

         }

         undef $datacenter_infos;

       }else{
         # Debug log for inventory
         $logger->debug("Can't auth with the sevrer ".$server_url);
       }

   }

}

sub manage_json_pp_bool{

  my $data_check;

  # Get passed arguments
  ($data_check) = @_;

  if ($data_check){
    return "true";
  }else{
    return "false";
  }

}

sub replace_string_to
{

  my $initial_string;
  my $replace_from;
  my $replace_to;

  # Get passed arguments
  ($initial_string, $replace_from, $replace_to) = @_;

  $replace_from = quotemeta $replace_from; # escape regex metachars if present

  $initial_string =~ s/$replace_from/$replace_to/g;

  return $initial_string;

}

# Auth to the vmware server
sub send_auth_api_query
{

  # Get passed arguments
  ($server_endpoint, $restpath, $auth_dig) = @_;

  $lwp_useragent = LWP::UserAgent->new;

  # set custom HTTP request header fields
  $req = HTTP::Request->new(POST => $server_endpoint . $restpath);
  $req->header('authorization' => "Basic $auth_dig");
  $req->header('cache-control' => 'no-cache');

  # Disable SSL Verify hostname
  $lwp_useragent->ssl_opts( verify_hostname => 0 ,SSL_verify_mode => 0x00);

  $resp = $lwp_useragent->request($req);
  if ($resp->is_success) {
      $message = $resp->decoded_content;
      return decode_json($message);
  }
  else {
      return $resp->message;
  }

}

# Query api and return the json decoded
sub send_api_query
{
  # get OCS Logger
  my $logger;
  my $filter;

  # Get passed arguments
  ($server_endpoint, $restpath, $session_id, $filter, $logger) = @_;

  $lwp_useragent = LWP::UserAgent->new;

  # set custom HTTP request header fields
  $req = HTTP::Request->new(GET => $server_endpoint . $restpath . $filter);
  $req->header('Accept' => 'application/json');
  $req->header('cache-control' => 'no-cache');
  $req->header('vmware-api-session-id' => $session_id);

  $logger->debug("Used url for api call : ". $server_endpoint . $restpath . $filter);

  # Disable SSL Verify hostname
  $lwp_useragent->ssl_opts( verify_hostname => 0 ,SSL_verify_mode => 0x00);

  $resp = $lwp_useragent->request($req);
  if ($resp->is_success) {
      $message = $resp->decoded_content;
      return decode_json($message);
  }
  else {
      return $resp->message;
  }
}

1;
