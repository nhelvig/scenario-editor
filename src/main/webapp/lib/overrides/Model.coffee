# This is where Backbone Model prototype methods are added.
# These methods will be added to all backbone models.
$a = window.beats

# Gets crudflag of backbone model
# @param flag CRUD flag to set to model
# @param offset Optional parameter to given
#   if using Split Ratio or Demand models
window.Backbone.Model::get_crud_flag = (flag, offset) ->
  # if offset is given pass on offset for split ratio and demand models
  if offset?
    @crud(offset)
  # for other models
  else
    @crud()

# Gets crudflag of backbone model
# @param flag CRUD flag to set to model
# @param offset Optional parameter to given
#   if using Split Ratio or Demand models
window.Backbone.Model::set_crud_flag = (flag, offset) ->
  # if offset is given pass on offset for split ratio and demand models
  if offset?
    switch @crud(offset)
      # When crudflag is not set, remove model if delete
      # otherwise change value to flag
      when null, undefined, $a.CrudFlag.NONE
        if flag == $a.CrudFlag.DELETE
          @remove()
        else
          @set_crud(flag, offset)

      # When crudflag is create it should not change at all,
      # however if going to delete element should be removed.
      when $a.CrudFlag.CREATE
        if flag == $a.CrudFlag.DELETE
          @remove()

      # when crudflag is updated it should only change to delete.
      when $a.CrudFlag.UPDATE
        if flag == $a.CrudFlag.DELETE
          @set_crud(flag, offset)

      # when crudflag is set to delete it should never change
      when $a.CrudFlag.DELETE
        console.log("Warning, Trying to change an already deleted " + @.constructor.name
          + " Backbone model with cid " + @cid)

  # for all other models
  else
    switch @crud()
      # When crudflag is not set, remove model if delete
      # otherwise change value to flag
      when null, undefined, $a.CrudFlag.NONE
        if flag == $a.CrudFlag.DELETE
          @remove()
        else
          @set_crud(flag)

      # When crudflag is create it should not change at all,
      # however if going to delete element should be removed.
      when $a.CrudFlag.CREATE
        if flag == $a.CrudFlag.DELETE
          @remove()

      # when crudflag is updated it should only change to delete.
      when $a.CrudFlag.UPDATE
        if flag == $a.CrudFlag.DELETE
          @set_crud(flag)

      # when crudflag is set to delete it should never change
      when $a.CrudFlag.DELETE
        console.log("Warning, Trying to change an already deleted " + @.constructor.name
          + " Backbone model with cid " + @cid)

# this removes the crudFlag and modstamp from any model object before calling
# the to_xml function
window.Backbone.Model::remove_crud_modstamp_for_xml = (doc) ->
  xml = ''
  # If we are converting to xml to be saved to file removed CRUDFlag and modstamp
  if window.beats? and window.beats.fileSaveMode
    crud = @crud()
    mod = @mod_stamp()
    @unset 'crudFlag', { silent:true }
    @unset 'mod_stamp', { silent:true }
    xml = @old_to_xml(doc)
    @set_crud(crud) if crud?
    @set_mod_stamp(mod) if mod?
  # Otherwise we are converting to xml to goto the database
  else
    xml = @old_to_xml(doc)
  xml
  
window.Backbone.Model::mod_stamp = -> @get('mod_stamp')
window.Backbone.Model::set_mod_stamp = (stamp) -> @set('mod_stamp', stamp)
