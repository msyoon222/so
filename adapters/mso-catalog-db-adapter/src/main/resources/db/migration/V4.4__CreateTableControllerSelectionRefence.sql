use catalogdb;
 
CREATE TABLE IF NOT EXISTS `controller_selection_reference` (
  `VNF_TYPE` VARCHAR(50) NOT NULL,
  `CONTROLLER_NAME` VARCHAR(100) NOT NULL,
  `ACTION_CATEGORY` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`VNF_TYPE`, `CONTROLLER_NAME`, `ACTION_CATEGORY`)
  ) ENGINE = InnoDB DEFAULT CHARSET=latin1;
