function stopPrintingProgressBar(obj)
  % Remove the progressBarText from the displayed text.

  obj.progressBarIsPrinted = false;
  obj.print();
end