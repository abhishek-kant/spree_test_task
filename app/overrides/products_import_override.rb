Deface::Override.new(:virtual_path => 'spree/admin/products/index',
                     :name => 'add_attrs_to_a_link',
                     :replace => "erb[loud]:contains('admin_new_product')",
                     partial: "spree/admin/products/index_action_buttons"

)