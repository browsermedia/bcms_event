jQuery(function($){
    
    //----- Helper Functions -----------------------------------------------------
    //In all of this code, we are defining functions that we use later
    //None of this actually manipulates the DOM in any way
    
    //This is used to get the id part of an elementId
    //For example, if you have section_node_5, 
    //you pass this 'section_node_5', 'section_node' 
    //and this returns 5
    var getId = function(elementId, s) {
	return elementId.replace(s,'')
    }
    
    var addHoverToSectionNodes = function() {
	$('#sitemap div.roundedcorners').hover(
	    function() { $(this).find('table.section_node').addClass('hover'); $(this).addClass('over')},
	    function() { $(this).find('table.section_node').removeClass('hover'); $(this).removeClass('over')}
	)    
    }
    
    var disableButtons = function() {
	$('a.button').addClass('disabled').click(function(){return false})
    }
    
    var makeMovableRowsDraggable = function() {
	$('#sitemap table.movable').draggable({
	    revert: 'invalid',
	    revertDuration: 200,
	    helper: 'clone',
	    delay: 200,
	    start: function(event, ui) {
		ui.helper.removeClass('hover').removeClass('selected')
	    }
	})    
    }
    
    var jsonPost = function(url, params) {
	if($.cms.authenticity_token && $.cms.authenticity_token != '') {
	    params['authenticity_token'] = $.cms.authenticity_token
	}
	$.post(url, params,
	       function(data){
		   if(data.success) {
		       $.cms.showNotice(data.message)
		   } else {
		       $.cms.showError(data.message)
		   }
	       }, "json"
	      );    
    }
    
    var moveSectionNode = function(sectionNodeId, move, otherSectionNodeId) {
	var url = '/cms/section_nodes/'+sectionNodeId+'/move_'+move
	var params = { _method: "PUT", section_node_id: otherSectionNodeId }
	jsonPost(url, params)
    }
    
    var moveSectionNodeToRoot = function(sectionNodeId, rootSectionId) {
	var url = '/cms/section_nodes/'+sectionNodeId+'/move_to_root'
	var params = { _method: "PUT", section_id: rootSectionId }
	jsonPost(url, params)
    }  
    
    var nodeOnDrop = function(e, ui) {    
	//Remove any drop zone highlights still hanging out
	$('#sitemap td.drop-before, #sitemap td.node, #sitemap td.drop-after').removeClass('drop-over')

	//Get the object and the id for the src (what we are droping) 
	//and the dest (where we are dropping)
	var src = ui.draggable.parents('ul:first') //The UL the TD is in
	    var sid = getId(src[0].id, 'section_node_')
	var dest = $(this).parents('ul:first') //The UL the drop zone is in
	    var did = getId(dest[0].id, 'section_node_')

	//If the src is a descendant of the dest, then forget it
	if(src == dest || $.inArray(src[0], dest.parents()) > -1) {
	    return true;
	}   

	if(dest.hasClass('root')) {
	    src.insertAfter(dest)
	    makeRootlet(src);
	    var rid = getId(dest[0].id, 'root_')
	    moveSectionNodeToRoot(sid, rid)
	    //Move to a section if the drop zone is the section
	} else {
	    unMakeRootlet(src);
	    if($(this).hasClass('node') && $(this).hasClass('section')) {      
		makeExpandable(dest);
		var move = 'to_end'
		    dest.find('li:first').append(src)
		openSection(dest[0])
		//If the drop zone is directly after an open section,
		//move this to the beginning of the section  
	    } else if($(this).hasClass('drop-after') && dest.find('table:first img.folder-open').length > 0) {
		var move = 'to_beginning'
		    src.insertAfter(dest.find('table:first'))
	    } else {
		//insert before or after, based on the class of the drop zone
		if (dest.hasClass('rootlet')) {
		    makeRootlet(src);
		}
		
		if($(this).hasClass('drop-before')) {
		    var move = 'before'
			src.insertBefore(dest)
		} else {
		    var move = 'after'          
			src.insertAfter(dest)      
		}
		
	    }
	    //Make the ajax call
	    moveSectionNode(sid, move, did)      

	}

	//Make the thing we are dropping be selected
	selectSectionNode(src)

    }

    var makeExpandable = function(dest) {
	var dest_toggle = dest.find('td.node:first img:first');
	dest_toggle.removeClass('no_folder_toggle');
	dest_toggle.addClass('folder_toggle');
	dest_toggle.click(toggleSectionOnClick);
	if (dest_toggle.hasClass('large')){
	    dest_toggle.attr('src','/images/cms/sitemap/gray_contract.png');	    
	} else {
	    dest_toggle.attr('src','/images/cms/sitemap/contract.png');
	}
    }

    var makeRootlet = function(src) {
	src.addClass('rootlet')
	var src_icon = src.find('td.node:first img:last')
	var src_icon_src = src_icon.attr('src')
	if(src_icon_src.indexOf('/root_') == -1) {
	    src_icon.attr('src',src_icon_src.replace(/\/([^/]+\.png).*/, '/root_$1'))
	}
    }
    
    var unMakeRootlet = function (src) {
	src.removeClass('rootlet')
	var src_icon = src.find('td.node:first img:last') 
	var src_icon_src = src_icon.attr('src')
	if (src_icon_src.indexOf('/root_') > -1) {
	    src_icon.attr('src',src_icon_src.replace(/\/root_([^/]+\.png).*/, '/$1'))
	}
    }
    
    var enableDropZones = function() {
	$('#sitemap td.drop-before, #sitemap td.node, #sitemap td.drop-after').droppable({
	    accept: 'table',
	    tolerance: 'pointer',
	    over: function(e, ui) {
		$(this).addClass('drop-over')
	    },
	    out: function(e, ui) {
		$(this).removeClass('drop-over')
	    },
	    drop: nodeOnDrop
	});    
    }
    
    var clearSelectedSectionNode = function() {
	disableButtons()
	$('#sitemap table.section_node').removeClass('selected');
	$('.roundedcorners').removeClass('on')
    }
    
    var selectSectionNode = function(sectionNode) {
	clearSelectedSectionNode(sectionNode)
	enableButtonsForSectionNode(sectionNode)
	$(sectionNode).find('table:first').addClass('selected');
	$(sectionNode).find('div.roundedcorners:first').addClass('on')
    }
    
    var isSectionEmpty = function(id) {
	return $('#section_'+id).parents('li:first').find('ul').length == 0    
    }
    
    var enableButtonsForSectionNode = function(sectionNode) {
	enableButtonsForNode($(sectionNode).find('td.node')[0])
    }
    
    var enableButtonsForNode = function(node) {
	var id = getId(node.id, /(section|page|link)_/);
	if(!$(node).is(".non-editable")) {
		if($(node).hasClass('section')) {
		    enableButtonsForSection(id);
		} else if($(node).hasClass('page')) {
		    enableButtonsForPage(id);
		} else if($(node).hasClass('link')) {
		    enableButtonsForLink(id);
		}  
	}else if($(node).hasClass('page')) {
	    $('#edit-button')
	        .html('<span>View Page</span>')
		.removeClass('disabled')
		.attr('href','/cms/pages/'+id)
		.unbind('click')
		.click(function(){return true});
	} else {
	    $('#properties-button').attr('href','/cms/sitemap');
	}
    };
    
    var enableButtonsForSection = function(id) {
	$('#properties-button')
	.removeClass('disabled')
	.attr('href','/cms/sections/'+id+'/edit')
	.unbind('click')
	.click(function(){return true})
	
	$('#add-page-button')
	.removeClass('disabled')
	.attr('href','/cms/sections/'+id+'/pages/new')
	.unbind('click')
	.click(function(){return true})

	$('#add-section-button')
	.removeClass('disabled')
	.attr('href','/cms/sections/new?section_id='+id)
	.unbind('click')
	.click(function(){return true})
	
	$('#add-link-button')
	.removeClass('disabled')
	.attr('href','/cms/sections/'+id+'/links/new')
	.unbind('click')
	.click(function(){return true}) 
	
	if(isSectionEmpty(id)) {
	    $('#delete-button')
            .removeClass('disabled')
            .attr('href','/cms/sections/'+id+'.json')
            .unbind('click')
            .click(function(){
		if(confirm('Are you sure you want to delete this section?')) {
		    var params = { _method: "DELETE" }
		    if($.cms.authenticity_token && $.cms.authenticity_token != '') {
			params['authenticity_token'] = $.cms.authenticity_token
		    }
		    $.post($(this).attr('href'), params,
			   function(data){
			       if(data.success) {
				   $.cms.showNotice(data.message)
			       } else {
				   $.cms.showError(data.message)
			       }
			   }, "json");
		    $('#section_'+id).parents('ul.section_node:first').remove()            
		}
		return false;
            })            
	} else {
	    $('#delete-button').addClass('disabled').unbind('click').click(function(){ return false})      
	}
        
    }
    
    var enableButtonsForPage = function(id) {
	$('#edit-button')
	.html('<span>Edit Page</span>')
	.removeClass('disabled')
	.attr('href','/cms/pages/'+id)
	.unbind('click')
	.click(function(){return true})

	$('#properties-button')
	.removeClass('disabled')
	.attr('href','/cms/pages/'+id+'/edit')
	.unbind('click')
	.click(function(){return true})

	$('#delete-button')
	.removeClass('disabled')
	.attr('href','/cms/pages/'+id+'.json')
	.unbind('click')
	.click(function(){
            if(confirm('Are you sure you want to delete this page?')) {
		var params = { _method: "DELETE" }
		if($.cms.authenticity_token && $.cms.authenticity_token != '') {
		    params['authenticity_token'] = $.cms.authenticity_token
		}
		$.post($(this).attr('href'), params,
		       function(data){
			   if(data.success) {
			       $.cms.showNotice(data.message)
			   } else {
			       $.cms.showError(data.message)
			   }
		       }, "json");
		$('#page_'+id).parents('ul.section_node:first').remove()            
            }
            return false;
	})    
    }
    
    var enableButtonsForLink = function(id) {
	$('#properties-button')
	.removeClass('disabled')
	.attr('href','/cms/links/'+id+'/edit')
	.unbind('click')
	.click(function(){return true})   
	
	$('#delete-button')
	.removeClass('disabled')
	.attr('href','/cms/links/'+id+'.json')
	.unbind('click')
	.click(function(){
            if(confirm('Are you sure you want to delete this link?')) {
		var params = { _method: "DELETE" }
		if($.cms.authenticity_token && $.cms.authenticity_token != '') {
		    params['authenticity_token'] = $.cms.authenticity_token
		}
		$.post($(this).attr('href'), params,
		       function(data){
			   if(data.success) {
			       $.cms.showNotice(data.message)
			   } else {
			       $.cms.showError(data.message)
			   }
		       }, "json");
		$('#link_'+id).parents('ul.section_node:first').remove()            
            }
            return false;
	})      
	
    }

    var openSection = function(sectionNode) {
	var id = getId(sectionNode.id, 'section_node_')
	
	//Remember to re-open this section
	$.cookieSet.add('openSectionNodes', id, {path: '/'})
	
	$(sectionNode).addClass('open')
	$(sectionNode).find('li:first > ul').show();
	var img = $(sectionNode).find('li:first table:first img.folder_toggle');
	if (img.hasClass('large')){
	img.attr('src','/images/cms/sitemap/gray_contract.png').addClass("folder-open")    
	} else {
	img.attr('src','/images/cms/sitemap/contract.png').addClass("folder-open")    
	}
    }
    
    var closeSection = function(sectionNode) {
	var id = getId(sectionNode.id, 'section_node_')
	
	//Remove this section from the set of open nodes
	$.cookieSet.remove('openSectionNodes', id, {path: '/'})

	//close this
	$(sectionNode).removeClass('open')
	$(sectionNode).find('li:first > ul').hide()
	var img = $(sectionNode).find('li:first table:first img.folder_toggle');
	if (img.hasClass('large')){
	img.attr('src','/images/cms/sitemap/gray_expand.png').removeClass("folder-open")    
	} else {
	img.attr('src','/images/cms/sitemap/expand.png').removeClass("folder-open")    
	}
    }
    
    var sectionNodeIsOpen = function(sectionNode) {
	return $(sectionNode).find('li:first table:first img.folder-open').length
    }
    
    var nodeOnClick = function() {
	
	var selected = $(this).hasClass('selected')
	clearSelectedSectionNode()
	$(this).addClass('selected')
	
	var node = $(this).find('td.node')[0]
	var id = getId(node.id, /(section|page|link)_/)
	var sectionNode = $(this).parents('ul:first')[0]
	
	selectSectionNode(sectionNode)
    }  

    var toggleSectionOnClick = function() {
	var sectionNode = $(this).parents('ul:first')[0]
	if(sectionNodeIsOpen(sectionNode)) {
	    closeSection(sectionNode)  
	} else {
	    openSection(sectionNode)
	}
    }
    
    var nodeOnDoubleClick = function() {
	if($('#edit-button').hasClass('disabled')) {
	    //$('#properties-button').click()
	    location.href = $('#properties-button')[0].href
	} else {
	    //$('#edit-button').click()      
	    location.href = $('#edit-button')[0].href
	}
    }
    
    var addNodeOnClick = function() {
	$('#sitemap table.section_node').click(nodeOnClick).dblclick(nodeOnDoubleClick)
    }
    
    var addToggleSectionOnClick = function(){
	$('#sitemap img.folder_toggle').click(toggleSectionOnClick);
    }
    
    //Whenever you open a section, a cookie is updated so that next time you view the sitemap
    //that section will start in open state
    var fireOnClickForOpenSectionNodes = function() {
	var openSectionNodeIds = $.cookieSet.get('openSectionNodes')
	var selectedSectionSelector = '.root table:first'
	    if(openSectionNodeIds) {
		$.each(openSectionNodeIds, function(i, e) { 
		    $('#section_node_'+e+' table:first img.folder_toggle').click()
		})            
		selectedSectionSelector = '#section_node_'+openSectionNodeIds[openSectionNodeIds.length-1]+' table:first'
	    }
	$(selectedSectionSelector).click()
    }  
    
    //----- Init -----------------------------------------------------------------
    //In other words, stuff that happens when the page loads
    //This is where we actually manipulate the DOM, fire events, etc.
    
    addHoverToSectionNodes()  
    disableButtons()
    makeMovableRowsDraggable()
    enableDropZones()  
    addNodeOnClick()
    addToggleSectionOnClick()
    fireOnClickForOpenSectionNodes()

})
