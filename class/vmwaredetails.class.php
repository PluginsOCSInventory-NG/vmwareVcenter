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

 /**
  * This class will show a detailed view of what's in the VCenter infrastructure
  */
class VmwareDetails {

  private $tableName = null;
  private $fieldArray = null;
  private $finalQuery = null;

  private $queryRepo = array(
    "SHOW_COLUMNS" => "SHOW COLUMNS FROM %s",
    "SELECT_FROM_TABLE" => "SELECT %s FROM %s"
  );

  public static $tableList = array(
    "VMWARE_DATACENTER",
    "VMWARE_DATASTORE",
    "VMWARE_CLUSTER",
    "VMWARE_FOLDER",
    "VMWARE_VM",
    "VMWARE_RESOURCEPOOL",
    "VMWARE_VM_DISK",
    "VMWARE_VM_HARDWARE",
    "VMWARE_VM_BOOT",
    "VMWARE_NETWORK",
  );

  public function setTableName($tableName){
    $this->tableName = $tableName
  }

  private function getTableFieldList(){
     $result = mysql2_query_secure($this->queryRepo['SHOW_COLUMNS'], $_SESSION['OCS']["readServer"], $this->tableName);

     while($row = $result->fetch_assoc()){
       if($row['Field'] != "HARDWARE_ID"){
          $this->fieldArray[] = $row['Field'];
       }
     }
  }

  private function generateQueryFromFieldList(){
     $fieldList = implode(', ', $this->fieldArray);
     $this->finalQuery =  sprintf($this->queryRepo['SELECT_FROM_TABLE'], $fieldList, $this->tableName);
  }

  private function generateDatatable(){

    if (AJAX) {
        parse_str($protectedPost['ocs']['0'], $params);
        $protectedPost += $params;
        ob_start();
    }

    $listFields = array();
    foreach ($this->fieldList as $field) {
      $listFields[$field] = $field;
    }
    $listFields = $defaultFields;

    $listColCantDel = array('ID' => 'ID');

    $tabOptions['form_name'] = $this->tableName;
    $tabOptions['table_name'] = $this->tableName;

    echo open_form($this->tableName, '', '', 'form-horizontal');

    ajaxtab_entete_fixe($listFields, $defaultFields, $tabOptions, $listColCantDel);

    echo close_form();

    if (AJAX) {
      ob_end_clean();
      tab_req($listFields, $defaultFields, $listColCantDel, $this->finalQuery, $tabOptions);
      ob_start();
    }
  }

  public function processTable($tabName){
    $this->setTableName($tabName);
    $this->getTableFieldList();
    $this->generateQueryFromFieldList();
    $this->generateDatatable();
  }

  public function processTableList(){
    foreach ($this->tableList as $tabName) {
      $this->processTable($tabName)
    }
  }

}
