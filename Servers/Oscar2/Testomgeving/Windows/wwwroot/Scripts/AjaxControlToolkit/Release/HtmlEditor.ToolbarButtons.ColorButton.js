﻿Type.registerNamespace("Sys.Extended.UI.HtmlEditor.ToolbarButtons");Sys.Extended.UI.HtmlEditor.ToolbarButtons.ColorButton=function(n){Sys.Extended.UI.HtmlEditor.ToolbarButtons.ColorButton.initializeBase(this,[n])};Sys.Extended.UI.HtmlEditor.ToolbarButtons.ColorButton.prototype={callMethod:function(){return Sys.Extended.UI.HtmlEditor.ToolbarButtons.ColorButton.callBaseMethod(this,"callMethod")?(this.openPopup(Function.createDelegate(this,this._onopened)),!0):!1},_onopened:function(n){n.setColor=Function.createDelegate(this,this.setColor)},setColor:function(){this.closePopup()}};Sys.Extended.UI.HtmlEditor.ToolbarButtons.ColorButton.registerClass("Sys.Extended.UI.HtmlEditor.ToolbarButtons.ColorButton",Sys.Extended.UI.HtmlEditor.ToolbarButtons.DesignModePopupImageButton);