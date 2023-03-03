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
 * This function is called on installation and is used to create database schema for the plugin
 */
function extension_install_vmware_vcenter()
{
    $commonObject = new ExtensionCommon;

    // VMWARE Vcenter datacenter
    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `VMWARE_DATACENTER` (
                          `ID` INT(11) NOT NULL AUTO_INCREMENT,
                          `HARDWARE_ID` INT(11) NOT NULL,
                          `HOST_FOLDER` VARCHAR(255) DEFAULT NULL,
                          `NETWORK_FOLDER` VARCHAR(255) DEFAULT NULL,
                          `VM_FOLDER` VARCHAR(255) DEFAULT NULL,
                          `DATACENTER_NAME` VARCHAR(255) DEFAULT NULL,
                          `DATASTORE_FOLDER` VARCHAR(255) DEFAULT NULL,
                          PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                          ) ENGINE=INNODB;");

    // VMWARE Vcenter datastore
    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `VMWARE_DATASTORE` (
                          `ID` INT(11) NOT NULL AUTO_INCREMENT,
                          `HARDWARE_ID` INT(11) NOT NULL,
                          `DATACENTER` VARCHAR(255) DEFAULT NULL,
                          `IS_ACCESSIBLE` VARCHAR(255) DEFAULT NULL,
                          `DATASTORE_NAME` VARCHAR(255) DEFAULT NULL,
                          `DATASTORE` VARCHAR(255) DEFAULT NULL,
                          `MULTIPLE_HOST_ACCESS` VARCHAR(255) DEFAULT NULL,
                          `CAPACITY` VARCHAR(255) DEFAULT NULL,
                          `FREE_SPACE` VARCHAR(255) DEFAULT NULL,
                          `THIN_PROVISIONING_SUPPORTED` VARCHAR(255) DEFAULT NULL,
                          `TYPE` VARCHAR(255) DEFAULT NULL,
                          PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                          ) ENGINE=INNODB;");

    // VMWARE Vcenter network
    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `VMWARE_NETWORK` (
                          `ID` INT(11) NOT NULL AUTO_INCREMENT,
                          `HARDWARE_ID` INT(11) NOT NULL,
                          `DATACENTER` VARCHAR(255) DEFAULT NULL,
                          `NETWORK` VARCHAR(255) DEFAULT NULL,
                          `NETWORK_NAME` VARCHAR(255) DEFAULT NULL,
                          `TYPE` VARCHAR(255) DEFAULT NULL,
                          PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                          ) ENGINE=INNODB;");

    // VMWARE Vcenter folder
    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `VMWARE_FOLDER` (
                          `ID` INT(11) NOT NULL AUTO_INCREMENT,
                          `HARDWARE_ID` INT(11) NOT NULL,
                          `DATACENTER` VARCHAR(255) DEFAULT NULL,
                          `FOLDER` VARCHAR(255) DEFAULT NULL,
                          `FOLDER_NAME` VARCHAR(255) DEFAULT NULL,
                          `TYPE` VARCHAR(255) DEFAULT NULL,
                          PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                          ) ENGINE=INNODB;");

    // VMWARE Vcenter cluster
    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `VMWARE_CLUSTER` (
                          `ID` INT(11) NOT NULL AUTO_INCREMENT,
                          `HARDWARE_ID` INT(11) NOT NULL,
                          `DATACENTER` VARCHAR(255) DEFAULT NULL,
                          `DRS_ENABLED` VARCHAR(255) DEFAULT NULL,
                          `HA_ENABLED` VARCHAR(255) DEFAULT NULL,
                          `CLUSTER_NAME` VARCHAR(255) DEFAULT NULL,
                          `CLUSTER` VARCHAR(255) DEFAULT NULL,
                          PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                          ) ENGINE=INNODB;");


    // VMWARE Vcenter res pool
    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `VMWARE_RESOURCEPOOL` (
                          `ID` INT(11) NOT NULL AUTO_INCREMENT,
                          `HARDWARE_ID` INT(11) NOT NULL,
                          `DATACENTER` VARCHAR(255) DEFAULT NULL,
                          `CLUSTER` VARCHAR(255) DEFAULT NULL,
                          `HOST` VARCHAR(255) DEFAULT NULL,
                          `RESOURCE_POOL` VARCHAR(255) DEFAULT NULL,
                          `RESOURCEPOOL_NAME` VARCHAR(255) DEFAULT NULL,
                          PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                          ) ENGINE=INNODB;");

    // VMWARE vm
    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `VMWARE_VM` (
                          `ID` INT(11) NOT NULL AUTO_INCREMENT,
                          `HARDWARE_ID` INT(11) NOT NULL,
                          `DATACENTER` VARCHAR(255) DEFAULT NULL,
                          `CLUSTER` VARCHAR(255) DEFAULT NULL,
                          `HOST` VARCHAR(255) DEFAULT NULL,
                          `RESOURCE_POOL` VARCHAR(255) DEFAULT NULL,
                          `VM` VARCHAR(255) DEFAULT NULL,
                          `CPU_COUNT` VARCHAR(255) DEFAULT NULL,
                          `POWER_STATE` VARCHAR(255) DEFAULT NULL,
                          `VM_NAME` VARCHAR(255) DEFAULT NULL,
                          `MEMORY_SIZE_MIB` VARCHAR(255) DEFAULT NULL,
                          `GUEST_OS` VARCHAR(255) DEFAULT NULL,
                          PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                          ) ENGINE=INNODB;");

    // VMWARE vm boot
    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `VMWARE_VM_BOOT` (
                          `ID` INT(11) NOT NULL AUTO_INCREMENT,
                          `HARDWARE_ID` INT(11) NOT NULL,
                          `VM` VARCHAR(255) DEFAULT NULL,
                          `ENTER_SETUP_MODE` VARCHAR(255) DEFAULT NULL,
                          `RETRY` VARCHAR(255) DEFAULT NULL,
                          `EFI_LEGACY_BOOT` VARCHAR(255) DEFAULT NULL,
                          `NETWORK_PROTOCOL` VARCHAR(255) DEFAULT NULL,
                          `DELAY` VARCHAR(255) DEFAULT NULL,
                          `RETRY_DELAY` VARCHAR(255) DEFAULT NULL,
                          `TYPE` VARCHAR(255) DEFAULT NULL,
                          PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                          ) ENGINE=INNODB;");

    // VMWARE vm hardware
    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `VMWARE_VM_HARDWARE` (
                          `ID` INT(11) NOT NULL AUTO_INCREMENT,
                          `HARDWARE_ID` INT(11) NOT NULL,
                          `VM` VARCHAR(255) DEFAULT NULL,
                          `VERSION` VARCHAR(255) DEFAULT NULL,
                          `UPGRADE_STATUS` VARCHAR(255) DEFAULT NULL,
                          `UPGRADE_VERSION` VARCHAR(255) DEFAULT NULL,
                          `UPGRADE_POLICY` VARCHAR(255) DEFAULT NULL,
                          PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                          ) ENGINE=INNODB;");

    // VMWARE vm cpu
    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `VMWARE_VM_CPU` (
                          `ID` INT(11) NOT NULL AUTO_INCREMENT,
                          `HARDWARE_ID` INT(11) NOT NULL,
                          `VM` VARCHAR(255) DEFAULT NULL,
                          `COUNT` VARCHAR(255) DEFAULT NULL,
                          `HOT_ADD_ENABLED` VARCHAR(255) DEFAULT NULL,
                          `HOT_REMOVE_ENABLED` VARCHAR(255) DEFAULT NULL,
                          `CORES_PER_SOCKET` VARCHAR(255) DEFAULT NULL,
                          PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                          ) ENGINE=INNODB;");

    // VMWARE vm memory
    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `VMWARE_VM_MEMORY` (
                        `ID` INT(11) NOT NULL AUTO_INCREMENT,
                        `HARDWARE_ID` INT(11) NOT NULL,
                        `VM` VARCHAR(255) DEFAULT NULL,
                        `HOT_ADD_INCREMENT_SIZE` VARCHAR(255) DEFAULT NULL,
                        `HOT_ADD_ENABLED` VARCHAR(255) DEFAULT NULL,
                        `HOT_ADD_LIMIT_MIB` VARCHAR(255) DEFAULT NULL,
                        `SIZE_MIB` VARCHAR(255) DEFAULT NULL,
                        PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                        ) ENGINE=INNODB;");

    // VMWARE vm net interface
    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `VMWARE_VM_NETINTERFACE` (
                        `ID` INT(11) NOT NULL AUTO_INCREMENT,
                        `HARDWARE_ID` INT(11) NOT NULL,
                        `VM` VARCHAR(255) DEFAULT NULL,
                        `KEY_REF` VARCHAR(255) DEFAULT NULL,
                        `WAKE_ON_LAN_ENABLED` VARCHAR(255) DEFAULT NULL,
                        `START_CONNECTED` VARCHAR(255) DEFAULT NULL,
                        `STATE` VARCHAR(255) DEFAULT NULL,
                        `MAC_TYPE` VARCHAR(255) DEFAULT NULL,
                        `MAC_ADDRESS` VARCHAR(255) DEFAULT NULL,
                        `UPT_COMPATIBILITY_ENABLED` VARCHAR(255) DEFAULT NULL,
                        `PCI_SLOT_NUMBER` VARCHAR(255) DEFAULT NULL,
                        `LABEL` VARCHAR(255) DEFAULT NULL,
                        `TYPE` VARCHAR(255) DEFAULT NULL,
                        `BACKING_DISTRIBUTED_SWITCH_UUID` VARCHAR(255) DEFAULT NULL,
                        `BACKING_DISTRIBUTED_PORT` VARCHAR(255) DEFAULT NULL,
                        `BACKING_NETWORK` VARCHAR(255) DEFAULT NULL,
                        PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                      ) ENGINE=INNODB;");

    // VMWARE vm disk
    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `VMWARE_VM_DISK` (
                          `ID` INT(11) NOT NULL AUTO_INCREMENT,
                          `HARDWARE_ID` INT(11) NOT NULL,
                          `VM` VARCHAR(255) DEFAULT NULL,
                          `KEY_REF` VARCHAR(255) DEFAULT NULL,
                          `BACKING_TYPE` VARCHAR(255) DEFAULT NULL,
                          `BACKING_VMDK_FILE` VARCHAR(255) DEFAULT NULL,
                          `LABEL` VARCHAR(255) DEFAULT NULL,
                          `TYPE` VARCHAR(255) DEFAULT NULL,
                          `CAPACITY` VARCHAR(255) DEFAULT NULL,
                          `SCSI_UNIT` VARCHAR(255) DEFAULT NULL,
                          `SCSI_BUS` VARCHAR(255) DEFAULT NULL,
                          PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                          ) ENGINE=INNODB;");
}

/**
 * This function is called on removal and is used to destroy database schema for the plugin
 */
function extension_delete_vmware_vcenter()
{
    $commonObject = new ExtensionCommon;
    // VMWARE Vcenter datacenter
    $commonObject -> sqlQuery("DROP TABLE `VMWARE_DATACENTER`;");
    // VMWARE Vcenter datastore
    $commonObject -> sqlQuery("DROP TABLE `VMWARE_DATASTORE`;");
    // VMWARE Vcenter network
    $commonObject -> sqlQuery("DROP TABLE `VMWARE_NETWORK`;");
    // VMWARE Vcenter folder
    $commonObject -> sqlQuery("DROP TABLE `VMWARE_FOLDER`;");
    // VMWARE Vcenter cluster
    $commonObject -> sqlQuery("DROP TABLE `VMWARE_CLUSTER`;");
    // VMWARE Vcenter res pool
    $commonObject -> sqlQuery("DROP TABLE `VMWARE_RESOURCEPOOL`;");
    // VMWARE vm
    $commonObject -> sqlQuery("DROP TABLE `VMWARE_VM`;");
    // VMWARE vm boot
    $commonObject -> sqlQuery("DROP TABLE `VMWARE_VM_BOOT`;");
    // VMWARE vm hardware
    $commonObject -> sqlQuery("DROP TABLE `VMWARE_VM_HARDWARE`;");
    // VMWARE vm cpu
    $commonObject -> sqlQuery("DROP TABLE `VMWARE_VM_CPU`;");
    // VMWARE vm memory
    $commonObject -> sqlQuery("DROP TABLE `VMWARE_VM_MEMORY`;");
    // VMWARE vm net interface
    $commonObject -> sqlQuery("DROP TABLE `VMWARE_VM_NETINTERFACE`;");
    // VMWARE vm disk
    $commonObject -> sqlQuery("DROP TABLE `VMWARE_VM_DISK`;");
}

/**
 * This function is called on plugin upgrade
 */
function extension_upgrade_vmware_vcenter()
{

}
