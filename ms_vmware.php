<?php
/*
 * Copyright 2005-2017 PluginsOCSInventory-NG/vmware-vcenter contributors.
 * See the Contributors file for more details about them.
 *
 * This file is part of PluginsOCSInventory-NG/vmware-vcenter.
 *
 * PluginsOCSInventory-NG/vmware-vcenter is free software: you can redistribute
 * it and/or modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * PluginsOCSInventory-NG/vmware-vcenter is distributed in the hope that it
 * will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with PluginsOCSInventory-NG/vmware-vcenter. if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 */

 if (AJAX) {
     parse_str($protectedPost['ocs']['0'], $params);
     $protectedPost += $params;
     ob_start();
 }

 require("class/vmwaredetails.class.php");

// Process Get
if(isset($_GET['list'])){
  $activeMenu = $_GET['list'];
}else{
  $activeMenu = "VMWARE_DATACENTER";
}

// Generate left menu
$details = new VmwareDetails();
echo "<div class='col-md-2'>";
$details->showVcenterLeftMenu($activeMenu);
echo "</div>";


$tabOptions = $protectedPost;
// Generate Right Tab with data
$tableDetails = $details->processTable($activeMenu);

$tabOptions['table_name'] = $tableDetails['tabOptions']['table_name'];
$tabOptions['form_name'] = $tableDetails['tabOptions']['form_name'];

echo "<div class='col-md-10'>";
echo open_form($tabOptions['table_name'], '', '', 'form-horizontal');
ajaxtab_entete_fixe($tableDetails['listFields'], $tableDetails['defaultFields'], $tabOptions,  $tableDetails['listColCantDel']);
echo close_form();
echo "</div>";

if (AJAX) {
  ob_end_clean();
  tab_req($tableDetails['listFields'], $tableDetails['defaultFields'], $tableDetails['listColCantDel'], $details->finalQuery, $tabOptions);
  ob_start();
}
