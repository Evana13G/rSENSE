   
$ ->
  
  csrf_token = $('meta[name=csrf-token]').attr('content');
  csrf_param = $('meta[name=csrf-param]').attr('content');
  
  turn_on_ck = (elem) =>
    root = ($ elem).parents('div.content_holder')
    root.parent().css('padding',"0px")
    row_id = ($ elem).attr('row_id')
    type = ($ elem).attr('type')
    field = ($ elem).attr('field')
    can_edit = ($ elem).attr('can_edit')

    path = ""
    if (csrf_param isnt undefined && csrf_token isnt undefined)
      params = csrf_param + "=" + encodeURIComponent(csrf_token);
      path =  "#{type}/#{row_id}?#{params}"
    
    if Boolean(can_edit)
      editor = CKEDITOR.replace elem,
        startupFocus: true
        filebrowserImageUploadUrl:  "/media_objects/saveMedia/#{path}"
      # Save previous value
      root.attr('saved-data',  root.find('div.content').html())
       
      saveButton = root.find('#content_save_button')
      cancelButton = root.find('#content_cancel_button')

      saveButton.show()
      cancelButton.show()
      
      cancelButton.click =>
        root.find('#content_edit').show()
        root.parent().css('padding',"20px")
        editor.destroy()
        root.find('div.content').html(root.attr('saved-data'))
        saveButton.hide()
        cancelButton.hide()
      
      saveButton.click =>
        root.find('#content_edit').show()
        root.parent().css('padding',"20px")
        value = editor.getData()
        data = {}
        data[type] = {}
        data[type][field] = value

        if type == "news"
          url = "/#{type}/#{row_id}"
        else
          url = "/#{type}s/#{row_id}"
  
        $.ajax
          url: url
          type: "PUT"
          dataType: "json"
          data: data
          success: =>
            # Save previous value now that it has updated
            root.attr('saved-data',  editor.getData())
            saveButton.hide()
            cancelButton.hide()
            editor.destroy()
      return editor
  
  ($ '#content_edit').click () ->
    ck = ($ document).find('.content:visible')[0]
    ($ @).hide()
    turn_on_ck(ck)
  
  ($ document).find('.content').each () ->
    root = ($ this).parents('div.content_holder')
    root.find('.add_content_link').click ->
      elem =  root.find('div.content')
      elem.show()
      ($ this).hide()
      editor = turn_on_ck(elem[0])
      
      if CKEDITOR.getTemplates('all')?
        editor.setData CKEDITOR.getTemplates('all').templates[0].html
      
      elem[0].focus()
      
      
      
  