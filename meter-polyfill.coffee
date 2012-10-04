###
HTML5 Meter polyfill | Jonathan Stipe | https://github.com/jonstipe/meter-polyfill
###
(($) ->
  document.createElement 'meter'
  $.fn.html5Meter = ->
    updatePolyfill = (meterElem, meterBarDiv) ->
      $meterElem = $ meterElem
      $meterBarDiv = $ meterBarDiv
      [min, max, val, high, low, optimal] = $([
        ($meterElem.attr('min') || '0'),
  		  ($meterElem.attr('max') || '1.0'),
  		  $meterElem.attr('value'),
  		  ($meterElem.attr('high') || ($meterElem.attr('max') || '1.0')),
  		  ($meterElem.attr('low') || ($meterElem.attr('min') || '0')),
  		  $meterElem.attr('optimum')]).map(() ->
        if /^\-?\d+(?:\.\d+)?$/.test this
  	      parseFloat this
      ).get()
      if val > max
        val = max
      if val < min
        val = min
      amt = if (max > min) then ((val - min) / (max - min)) * 100.0 else 0
      if val > high
        $meterBarDiv.addClass 'meter-high'
      else
        $meterBarDiv.removeClass 'meter-high'
      if val < low
        $meterBarDiv.addClass 'meter-low'
      else
        $meterBarDiv.removeClass 'meter-low'
      if val == optimal
        $meterBarDiv.addClass 'meter-optimal'
      else
        $meterBarDiv.removeClass 'meter-optimal'
      $meterBarDiv.css "width", amt + "%"
      null
    $(this).filter('meter').each ->
      $elem = $ this
      meterFrameDiv = document.createElement 'div'
      meterBarDiv = document.createElement 'div'
      meterFrameDiv.appendChild meterBarDiv
      $(meterFrameDiv).addClass 'meter-frame'
      $(meterBarDiv).addClass 'meter-bar'
      updatePolyfill this, meterBarDiv
      this.appendChild meterFrameDiv
      if (WebKitMutationObserver? || MutationObserver?)
        attrMutationCallback = (mutations, observer) =>
          (
            if mutation.type == "attributes" && mutation.attributeName in ["value", "min", "max", "low", "high", "optimum"]
              updatePolyfill this, meterBarDiv
          ) for mutation in mutations
          null
        attrObserver = if (WebKitMutationObserver?) then new WebKitMutationObserver(attrMutationCallback) else (if (MutationObserver?) then new MutationObserver(attrMutationCallback) else null)
        attrObserver.observe this, {
          attributes: true
          attributeFilter: ["value", "min", "max", "low", "high", "optimum"]
        }
      else if MutationEvent?
        $elem.on "DOMAttrModified", (evt) =>
          if evt.originalEvent.attrName in ["value", "min", "max", "low", "high", "optimum"]
            updatePolyfill this, meterBarDiv
          null
      null
    $(this)
  $ ->
    $('meter').html5Meter()
    null
  null
)(jQuery)
