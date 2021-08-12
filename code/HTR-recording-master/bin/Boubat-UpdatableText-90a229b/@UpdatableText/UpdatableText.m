classdef UpdatableText < handle
% message = UpdatableText()
% message = UpdatableText(prefix)
% message = UpdatableText(prefix,suffix)
%
% Use the print(text) method to update the text printed in the command window.
% Use the printAbove(text) method to print a non-updatable text above the 
% current updatable text.
%
% The format string can contain three specific keywords:
%   '_prefix' will be replaced by the value in the 'prefix' property.
%   '_text' will be replaced by the value in the 'text' property.
%   '_suffix' will be replaced by the value in the 'suffix' property.
% The default format string is: '_prefix_text_suffix\n'
% 
% Beware not to print anything else in the command window while
% an UpdatabaleText is being used since updating an UpdatableText
% deletes characters among the last printed characters.

  properties (Access = protected)
    lastPrintLength = 0;

    prefix = '';
    text = '';
    suffix = '';

    textToDisplay = '';
    formatString = '';
    formatFunctions = {};
  end



  methods

    function obj = UpdatableText(varargin)
      if nargin >= 1
        obj.prefix = varargin{1};
      end
      if nargin >= 2
        obj.suffix = varargin{2};
      end
      obj.setFormatFunctions(@(obj)obj.replaceInTextToDisplay('_prefix',obj.prefix),...
        @(obj)obj.replaceInTextToDisplay('_text',obj.text),...
        @(obj)obj.replaceInTextToDisplay('_suffix',obj.suffix));
      obj.setFormatString('_prefix_text_suffix\n');
    end

    function set.prefix(obj,value)
      assert(ischar(value),'Prefix must be a char array.');
      obj.prefix = value;
    end

    function set.text(obj,value)
      assert(ischar(value),'Text must be a char array.');
      obj.text = value;
    end

    function set.suffix(obj,value)
      assert(ischar(value),'Suffix must be a char array.');
      obj.suffix = value;
    end
    
    function set.formatString(obj,value)
      assert(ischar(value),'Format string must be a char array.');
      obj.formatString = value;
    end

    function set.formatFunctions(obj,value)
      all(cellfun(@(argument)isa(argument,'function_handle'),value));
      obj.formatFunctions = value;
    end

  end


  methods (Access = protected)
    
    updateTextToDisplay(obj);
    formerTextDeleter = getFormerTextPrintableDeleter(obj);
    setFormatFunctions(obj,varargin);
    replaceInTextToDisplay(obj,formatString,printedString);
    
  end
  
  
end