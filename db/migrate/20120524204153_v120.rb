# Upgrades the bcms_event module to v1.2.0
class V120 < ActiveRecord::Migration
  def change
    v3_5_0_apply_namespace_to_block("BcmsEvent", "Event")
  end
  
end
