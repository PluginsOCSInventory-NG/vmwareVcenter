# Plugin VMWare VCenter

<p align="center">
  <img src="https://cdn.ocsinventory-ng.org/common/banners/banner660px.png" height=300 width=660 alt="Banner">
</p>

<h1 align="center">Plugin VMWare VCenter</h1>
<p align="center">
  <b>Some Links:</b><br>
  <a href="http://ask.ocsinventory-ng.org">Ask question</a> |
  <a href="https://www.ocsinventory-ng.org/?utm_source=github-ocs">Website</a> |
  <a href="https://www.ocsinventory-ng.org/en/#ocs-pro-en">OCS Professional</a>
</p>

## Description

This plugin is made to retrieve all VCenter informations using the new REST api from VMWare VCenter.
Link : https://code.vmware.com/apis/62/vcenter-management

*NOTE : This plugin is missing some VCenter VM inventoried data (WIP)*

## Prerequisite

*The following configuration need to be installed on your VCenter :*
1. VCenter 6.5 and newer (see link above)
2. A user with read rights on the API and VCenter infrastructure

*The following OCS configuration need to be installed :*
1. Unix agent 2.3 and newer
2. OCS Inventory 2.3.X recommended

*The following dependencies need to be installed on agent :*
1. LWP::UserAgent
2. JSON

## Used API routes

This following routes are used by the API :
- myvcenterserver/rest/com/vmware/cis/session
- myvcenterserver/rest/vcenter/datacenter"
- myvcenterserver/rest/vcenter/datacenter/{details}"
- myvcenterserver/rest/vcenter/resource-pool"
- myvcenterserver/rest/vcenter/resource-pool/{details}"
- myvcenterserver/rest/vcenter/cluster"
- myvcenterserver/rest/vcenter/cluster/{details}"
- myvcenterserver/rest/vcenter/host"
- myvcenterserver/rest/vcenter/datastore"
- myvcenterserver/rest/vcenter/datastore/{details}"
- myvcenterserver/rest/vcenter/folder"
- myvcenterserver/rest/vcenter/network"
- myvcenterserver/appliance/system/version"
- myvcenterserver/appliance/system/uptime"
- myvcenterserver/rest/vcenter/vm"
- myvcenterserver/rest/vcenter/vm/{vmid}"

## Configuration

To configure a new server to scan you need to edit the Vmware.pm file.

Line 18 :  
```
my @auth_hashes = (
    {
       URL  => "MY_FIRST_VMWARE_SERVER",
       AUTH_DIG     => "My Auth digest (user:pass encoded in base 64)",
    },
    {
       URL => "MY_SECOND_VMWARE_SERVER",
       AUTH_DIG    => "My Auth digest (user:pass encoded in base 64)",
    },
);
```

You need to change the URL to your VMWare server url / ip and set the AUTH_DIG to user + pass encoded in base 64

If you have more than one server you need to add the following line below the last URL + AUTH_DIG values :

```
    {
       URL => "MY_THIRD_VMWARE_SERVER",
       AUTH_DIG    => "My Auth digest (user:pass encoded in base 64)",
    },
```

*Note : there is no limit on server number*

## Todo

1. Add GUI representations for inventoried data in ocsreports
