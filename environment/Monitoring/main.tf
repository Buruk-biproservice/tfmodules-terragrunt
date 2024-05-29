module "infrastructure" {
  source =  "../../modules/infrastructure"
    region_location = "germanywestcentral"
  }

module "converter" {
  source   = "../../modules/converter"
  convname = "monitoring/biproconverter"
}