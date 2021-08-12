classdef ProgressionDisplay < UpdatableText
% progression = ProgressionDisplay()
% progression = ProgressionDisplay(prefix)
% progression = ProgressionDisplay(prefix,suffix)
%
% Use the print(text) method to update the text printed in the command window.
% Use the printAbove(text) method to print a non-updatable text above the 
% current updatable text.
%
% Use the startPrintingPercent(), startPrintingProgressBar(), and 
% startPrintingStep() methods to add the corresponding progression display to
% the displayed text. The progress bar display is cutomizable through the
% setProgressBarLength(newProgressBarLength) method.
%
% Use the updateStep(currentStep) and updateStep(currentStep,maxStep) methods
% to update the progression state and the displayed text.
%
% Use the stopPrintingPercent(), stopPrintingProgressBar(), and 
% stopPrintingStep() methods to remove the corresponding progression display from
% the displayed text.
%
% The format string can contain six specific keywords:
%   '_prefix' will be replaced by the value in the 'prefix' property.
%   '_text' will be replaced by the value in the 'text' property.
%   '_suffix' will be replaced by the value in the 'suffix' property.
%   '_step' will be replaced by the value in the 'stepText' property.
%   '_percent' will be replaced by the value in the 'percentText' property.
%   '_progressbar' will be replaced by the value in the 'progressBarText' property.
% The default format string is: '_prefix_text_step_percent_progressbar_suffix\n'
% 
% Beware not to print anything else in the command window while
% an ProgressionDisplay is being used since updating an ProgressionDisplay
% deletes characters among the last printed characters.

  properties (Access = protected)
    currentStep = 0;
    maxStep = 1;
    progressFraction = 0;

    percentText = '';
    percentTextIsPrinted = false;

    progressBarText = '';
    progressBarLength = 20;
    progressBarIsPrinted = false;
    
    stepText = '';
    stepTextIsPrinted = false;
  end

  methods (Access = protected)
    
    updatePercentText(obj);
    updateProgressBarText(obj);
    updateStepText(obj);
    updateProgressFraction(obj);
    
  end


  methods 
    
    function obj = ProgressionDisplay(varargin)
      obj@UpdatableText(varargin{:});
      obj.setFormatFunctions(@(obj)obj.replaceInTextToDisplay('_prefix',obj.prefix),...
        @(obj)obj.replaceInTextToDisplay('_text',obj.text),...
        @(obj)obj.replaceInTextToDisplay('_suffix',obj.suffix),...
        @(obj)obj.replaceInTextToDisplay('_step',obj.stepText),...
        @(obj)obj.replaceInTextToDisplay('_percent',obj.percentText),...
        @(obj)obj.replaceInTextToDisplay('_progressbar',obj.progressBarText));
      obj.setFormatString('_prefix_text_step_percent_progressbar_suffix\n');
    end
    
    function set.currentStep(obj,value)
      assert(isequal(size(value),[1 1]),'currentStep must be a positive integer.')
      assert(isnumeric(value),'currentStep must be a positive integer.')
      assert(value >= 0,'currentStep must be a positive integer.')
      assert(value <= obj.maxStep,'currentStep must be lesser than maxStep.')
      obj.currentStep = value;
      obj.updateProgressFraction();
    end

    function set.maxStep(obj,value)
      assert(isequal(size(value),[1 1]),'maxStep must be a positive integer.')
      assert(isnumeric(value),'maxStep must be a positive integer.')
      assert(value > 0,'maxStep must be greater than 0.')
      obj.maxStep = value;
      obj.updateProgressFraction();
    end
    
    function set.progressBarLength(obj,value)
      assert(isequal(size(value),[1 1]),'progressBarLength must be a positive integer.')
      assert(isnumeric(value),'progressBarLength must be a positive integer.')
      obj.progressBarLength = value;
      obj.updateProgressBarText();
    end

  end

end