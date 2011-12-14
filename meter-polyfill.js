$(function(){
  document.createElement('meter');
  var updatePolyfill = function(meterElem, meterBarDiv) {
    var params = $([($(meterElem).attr('min') || '0'),
		  ($(meterElem).attr('max') || '1.0'),
		  $(meterElem).attr('value'),
		  ($(meterElem).attr('high') || ($(meterElem).attr('max') || '1.0')),
		  ($(meterElem).attr('low') || ($(meterElem).attr('min') || '0')),
		  $(meterElem).attr('optimum')]).map(function() {
      if (/^\-?\d+(?:\.\d+)?$/.test(this)) {
	return parseFloat(this);
      }
    }).get();
    var min = params[0];
    var max = params[1];
    var val = params[2];
    var high = params[3];
    var low = params[4];
    var optimal = params[5];
    if (val > max) val = max;
    if (val < min) val = min;
    var amt = ((val - min) / (max - min)) * 100.0;
    if (val > high) {
      $(meterBarDiv).addClass('meter-high');
    } else if (val < low) {
      $(meterBarDiv).addClass('meter-low');
    }
    if (val == optimal) {
      $(meterBarDiv).addClass('meter-optimal');
    }
    meterBarDiv.style.width = amt + "%";
  };
  $('meter').each(function(index) {
    var meterFrameDiv = document.createElement('div');
    var meterBarDiv = document.createElement('div');
    meterFrameDiv.appendChild(meterBarDiv);
    $(meterFrameDiv).addClass('meter-frame');
    $(meterBarDiv).addClass('meter-bar');
    updatePolyfill(this, meterBarDiv);
    this.appendChild(meterFrameDiv);
    $(this).bind("DOMAttrModified", function(event) {
      updatePolyfill(this, meterBarDiv);
    });
  });
});