function setFormatFunctions(obj,varargin)
  % All these so called format functions are executed by the method updateTextToDisplay().
  % They are used to create the text to display from the current formatString.
  % They should all modify the property textToDisplay somehow.

  obj.formatFunctions = varargin;
end