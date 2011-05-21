module ApplicationHelper
	def articulo_link(link_text, articulo) # AQ dodgy performance
		remote_tr_show_link(link_text, articulo, articulo_path(articulo)) 
	end
	def entrega_link(link_text, entrega)
		remote_tr_show_link(link_text, entrega, entrega_path(entrega)) 
	end

  def remote_tr_show_link(link_text, object, href, zindex = false) 
    # updates the 'overlay' dom id and sets the object id in the 'class_name_id' dom id for quick retrieval if clicked again
		class_name = object.class.to_s.downcase
		row_id = class_name + "_" + object.id.to_s
		data_dom = "overlay"
		id_dom = class_name + "_id"
		#before_js = "$('#{data_dom}').innerHTML = '';" + visual_effect(:appear, data_dom, :duration => 0.4)
		#before_js += ";$('z_index').innerHTML = parseInt($('z_index').innerHTML) + 1" if zindex
		before_js = "$('z_index').innerHTML = parseInt($('z_index').innerHTML) + 1" if zindex
		link_to_function(
			link_text,
			"if ($('#{id_dom}').innerHTML == '" + object.id.to_s + "') 
				{" + visual_effect(:Opacity, row_id, :from => 1.0, :to => 0.3, :duration => 0) + ";
				 Element.toggle('#{data_dom}')}
			else if ($('#{data_dom}').style.display == 'none') {" +
				remote_function(
					:update => data_dom,
					:before => before_js ,
					:after => visual_effect(:Opacity, row_id, :from => 1.0, :to => 0.3, :duration => 0.4) ,
					:complete => visual_effect(:appear, data_dom, :duration => 0.4) + ";" +
								"$('#{id_dom}').innerHTML = '" + object.id.to_s + "';" +
								(!zindex ? "" : "$('#{data_dom}').style.zIndex = parseInt($('z_index').innerHTML);"),
					:url => href, 
					:method => :get) + 
			"}",
			:title => "Click to see details",
			:href => href)
	 end

end
