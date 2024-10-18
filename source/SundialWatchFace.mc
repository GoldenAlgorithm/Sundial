import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

typedef ComplicationType as Number or String;
typedef Area as [Number, Number, Number, Number]; // x, y, width, height

class SundialWatchFace extends WatchUi.WatchFace {
  private var _isInHighPowerMode as Boolean = true;
  private var _font as VectorFont = Graphics.getVectorFont({ :face => "RobotoCondensedBold", :size => 48}); //TODO > Font size OK??
  
  private var _complications as Array<ComplicationType> = [0, 0, 100, 0, 0, 0, 0, 0];
  private var _complicationsAreas as [Area?, Area?, Area?, Area?, Area?, Area?, Area?, Area?] = [null, null, null, null, null, null, null, null];  
  
  var screenRadius as Float = SundialAppSettings.getScreenWidth() <= SundialAppSettings.getScreenHeight() ? SundialAppSettings.getScreenWidth() / 2.0 : SundialAppSettings.getScreenHeight() / 2.0;
  var screenCenter as [Float, Float] = [screenRadius, screenRadius];

  var marksLength = 10.0;
  var hourHandWidth = 20.0;
  var hourHandLength = screenRadius * 2.0 / 3.0;
  var hourHandBorder = 5.0;
  var minuteHandWidth = 20.0;
  var minuteHandLength = screenRadius;
  var minuteHandBorder = 5.0;
  var secondHandWidth = 4.0;
  var secondHandLength = minuteHandLength;
  var secondHandTipLength = 16.0;
  var marks60Polygon = [[-1.0, -screenRadius + marksLength], [-1.0, -screenRadius], [1.0, -screenRadius], [1.0, -screenRadius + marksLength]];
  var marks12Polygon = [[-3.0, -screenRadius + marksLength * 2.0], [-3, -screenRadius], [3.0, -screenRadius], [3.0, -screenRadius + marksLength * 2.0]];
  var marks4Polygon = [[-5.0, -screenRadius + marksLength * 3.0], [-5, -screenRadius], [5.0, -screenRadius], [5.0, -screenRadius + marksLength * 3.0]];
  var complicationPositionRadius = screenRadius * 4.0 / 8.0;
  var complicationCoordinate = [0.0, -complicationPositionRadius];
  var hourHandLeftSidePolygon = [[0.0, 0.0], [-hourHandWidth/2.0, 0.0], [-hourHandWidth/2.0, -hourHandLength+hourHandWidth/2.0], [0.0, -hourHandLength]];
  var hourHandRightSidePolygon = [[0.0, 0.0], [hourHandWidth/2.0, 0.0], [hourHandWidth/2.0, -hourHandLength+hourHandWidth/2.0], [0.0, -hourHandLength]];
  var hourHandInnerPolygon = [[-hourHandWidth/2.0+hourHandBorder, -hourHandWidth-hourHandBorder], [-hourHandWidth/2.0+hourHandBorder, -hourHandLength+hourHandWidth/2.0+hourHandBorder], [hourHandWidth/2.0-hourHandBorder, -hourHandLength+hourHandWidth/2.0+hourHandBorder], [hourHandWidth/2.0-hourHandBorder, -hourHandWidth-hourHandBorder]];
  var minuteHandLeftSidePolygon = [[0.0, 0.0], [-minuteHandWidth/2.0, 0.0], [-minuteHandWidth/2.0, -minuteHandLength+minuteHandWidth/2.0], [0.0, -minuteHandLength]];
  var minuteHandRightSidePolygon = [[0.0, 0.0], [minuteHandWidth/2.0, 0.0], [minuteHandWidth/2.0, -minuteHandLength+minuteHandWidth/2.0], [0.0, -minuteHandLength]];
  var minuteHandInnerPolygon = [[-minuteHandWidth/2.0+minuteHandBorder, -minuteHandWidth-minuteHandBorder], [-minuteHandWidth/2.0+minuteHandBorder, -minuteHandLength+minuteHandWidth/2.0+minuteHandBorder], [minuteHandWidth/2.0-minuteHandBorder, -minuteHandLength+minuteHandWidth/2.0+minuteHandBorder], [minuteHandWidth/2.0-minuteHandBorder, -minuteHandWidth-minuteHandBorder]];
  var secondHandPolygon = [[-secondHandWidth / 2.0, 0.0], [-secondHandWidth / 2.0, -secondHandLength + secondHandTipLength], [secondHandWidth / 2.0, -secondHandLength + secondHandTipLength], [secondHandWidth / 2.0, 0.0]];
  var secondHandTipPolygon = [[-secondHandWidth / 2.0, -secondHandLength + secondHandTipLength], [-secondHandWidth / 2.0, -secondHandLength + secondHandWidth / 2.0], [0, -secondHandLength], [secondHandWidth / 2.0, -secondHandLength + secondHandWidth / 2.0], [secondHandWidth / 2.0, -secondHandLength + secondHandTipLength]];
  

  function initialize() {
      WatchFace.initialize();
  }

  function onLayout(dc as Dc) as Void {
    dc.setAntiAlias(true);
  }

  function onShow() as Void {
  }

  function onUpdate(dc as Dc) as Void {
    
    var theme = SundialAppSettings.THEMES[SundialAppSettings.getThemeIndex()];

    //NOTE > System.getDisplayMode() causes hickups
    if (_isInHighPowerMode) {
      drawHighPowerWatchFace(dc, theme);
    } else {
      drawLowPowerWatchFace(dc, theme);
    }
  }

  function onHide() as Void {
  }

  function onExitSleep() as Void {
    _isInHighPowerMode = true;
    requestUpdate();
  }

  function onEnterSleep() as Void {
    _isInHighPowerMode = false;
    requestUpdate();
  }

  function drawHighPowerWatchFace(dc as Dc, _theme as Dictionary<String, String or Number>) as Void {
    dc.setColor(_theme["HighPowerBackgroundColor"], _theme["HighPowerBackgroundColor"]);
    dc.clear();

    var dateTime = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
    var hourHandAngle = dateTime.hour % 12 * Math.PI / 6 + dateTime.min * Math.PI / 360;
    var minuteHandAngle = dateTime.min * Math.PI / 30;
    var secondHandAngle = dateTime.sec * Math.PI / 30;
    var isHourHandShadeRight = hourHandAngle >= 0.0 && hourHandAngle < Math.PI;
    var isMinuteHandShadeRight = minuteHandAngle >= 0.0 && minuteHandAngle < Math.PI;
    var affineTransform = new Graphics.AffineTransform();
    
    //Draw marks
    for (var i = 0; i < 60; i++) {
      affineTransform.setToTranslation(screenCenter[0], screenCenter[1]);
      affineTransform.rotate(i * Math.PI / 30);
      dc.setColor(_theme["HighPowerMarksColor"], _theme["HighPowerBackgroundColor"]);
      if (i == 0 || i == 15 || i == 30 || i == 45) {
        dc.fillPolygon(affineTransform.transformPoints(marks4Polygon));
        dc.setColor(_theme["HighPowerBackgroundColor"], _theme["HighPowerBackgroundColor"]);
        dc.fillPolygon(affineTransform.transformPoints(marks12Polygon));
      } else if (i % 5 == 0) {
        dc.fillPolygon(affineTransform.transformPoints(marks12Polygon));
        dc.setColor(_theme["HighPowerBackgroundColor"], _theme["HighPowerBackgroundColor"]);
        dc.fillPolygon(affineTransform.transformPoints(marks60Polygon));
      } else {
        dc.fillPolygon(affineTransform.transformPoints(marks60Polygon));
      }
    }

    //Draw complications
    //for (var i = 0; i <= 7; i++) {
    //  var line1 = "";
    //  var line2 = "";
    //  if (_complications[i] == 0) {
    //    continue;
    //  } else if (_complications[i] instanceof String) {
    //    line2 = _complications[i];
    //  } else {
    //    if (_complications[i] == 100) {
    //      line1 = dateTime.day_of_week.toString();
    //      line2 = dateTime.day.toString() + " " + dateTime.month.toString();
    //    } else {
    //      switch (_complications[i]) {
    //        case Complications.COMPLICATION_TYPE_BATTERY:
    //          line2 = Complications.getComplication(new Complications.Id(Complications.COMPLICATION_TYPE_BATTERY)).value.toString();
    //          break;
    //        default:
    //          break;
    //      }
    //    }
    //  }
    //  affineTransform.setToTranslation(screenCenter[0], screenCenter[1]);
    //  affineTransform.rotate(i * Math.PI / 4.0);
    //  var centerPointComplication = affineTransform.transformPoint(complicationCoordinate);
    //  var dimensionsLine1 = dc.getTextDimensions(line1, _font);
    //  var dimensionsLine2 = dc.getTextDimensions(line2, _font);
    //  var widthHeightComplication = [dimensionsLine1[0] > dimensionsLine2[0] ? dimensionsLine1[0] : dimensionsLine2[0], dimensionsLine1[1] + dimensionsLine2[1]];
    //  _complicationsAreas[i] =  [centerPointComplication[0] - widthHeightComplication[0] / 2, centerPointComplication[1] - widthHeightComplication[1] / 2, widthHeightComplication[0], widthHeightComplication[1]];
    //  dc.drawText(centerPointComplication[0], centerPointComplication[1] - 20, _font, line1, Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
    //  dc.drawText(centerPointComplication[0], centerPointComplication[1] + 20, _font, line2, Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
    //}
  
    //HACK > [DATE] compilation => Long press opens calendar events
    //TODO > Cleanup and implement mess above
    var line1 = dateTime.day_of_week.toString();
    var line2 = dateTime.day.toString() + " " + dateTime.month.toString();
    affineTransform.setToTranslation(screenCenter[0], screenCenter[1]);
    affineTransform.rotate(2 * Math.PI / 4.0);
    var centerPointComplication = affineTransform.transformPoint(complicationCoordinate);
    var dimensionsLine1 = dc.getTextDimensions(line1, _font);
    var dimensionsLine2 = dc.getTextDimensions(line2, _font);
    var widthHeightComplication = [dimensionsLine1[0] > dimensionsLine2[0] ? dimensionsLine1[0] : dimensionsLine2[0], dimensionsLine1[1] + dimensionsLine2[1]];
    _complicationsAreas[2] =  [centerPointComplication[0] - widthHeightComplication[0] / 2, centerPointComplication[1] - widthHeightComplication[1] / 2, widthHeightComplication[0], widthHeightComplication[1]];
    dc.setColor(_theme["HighPowerComplicationColor"], _theme["HighPowerBackgroundColor"]);
    dc.drawText(centerPointComplication[0], centerPointComplication[1] - 24, _font, line1, Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);
    dc.drawText(centerPointComplication[0], centerPointComplication[1] + 24, _font, line2, Graphics.TEXT_JUSTIFY_VCENTER | Graphics.TEXT_JUSTIFY_CENTER);

  
    //Draw hour hand
    affineTransform.setToTranslation(screenCenter[0], screenCenter[1]);
    affineTransform.rotate(hourHandAngle);
    if (isHourHandShadeRight) {
      dc.setColor(_theme["HighPowerHandsLightColor"], _theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(hourHandLeftSidePolygon));
      dc.setColor(_theme["HighPowerHandsDarkColor"], _theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(hourHandRightSidePolygon));
    } else {
      dc.setColor(_theme["HighPowerHandsDarkColor"], _theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(hourHandLeftSidePolygon));
      dc.setColor(_theme["HighPowerHandsLightColor"], _theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(hourHandRightSidePolygon));
    }
    dc.setColor(_theme["AccentColor"], _theme["HighPowerBackgroundColor"]);
    dc.fillPolygon(affineTransform.transformPoints(hourHandInnerPolygon));

    //Draw minute hand
    affineTransform.setToTranslation(screenCenter[0], screenCenter[1]);
    affineTransform.rotate(minuteHandAngle);
      if (isMinuteHandShadeRight) {
        dc.setColor(_theme["HighPowerHandsLightColor"], _theme["HighPowerBackgroundColor"]);
        dc.fillPolygon(affineTransform.transformPoints(minuteHandLeftSidePolygon));
        dc.setColor(_theme["HighPowerHandsDarkColor"], _theme["HighPowerBackgroundColor"]);
        dc.fillPolygon(affineTransform.transformPoints(minuteHandRightSidePolygon));
      } else {
        dc.setColor(_theme["HighPowerHandsDarkColor"], _theme["HighPowerBackgroundColor"]);
        dc.fillPolygon(affineTransform.transformPoints(minuteHandLeftSidePolygon));
        dc.setColor(_theme["HighPowerHandsLightColor"], _theme["HighPowerBackgroundColor"]);
        dc.fillPolygon(affineTransform.transformPoints(minuteHandRightSidePolygon));
      }
      dc.setColor(_theme["AccentColor"], _theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(minuteHandInnerPolygon));
      
      //Draw second hand
      affineTransform.setToTranslation(screenCenter[0], screenCenter[1]);
      affineTransform.rotate(secondHandAngle);
      dc.setColor(_theme["AccentColor"], _theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(secondHandTipPolygon));
      dc.setColor(_theme["HighPowerSecondHandColor"], _theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(secondHandPolygon));
      
      //Draw center circle
      dc.setColor(_theme["HighPowerBackgroundColor"], _theme["HighPowerBackgroundColor"]);
      dc.fillCircle(screenCenter[0], screenCenter[1], hourHandWidth/2.0+hourHandBorder);
      dc.setColor(_theme["HighPowerSecondHandColor"], _theme["HighPowerBackgroundColor"]); //TODO > Second hand color?? Maybe cleanup colors
      dc.fillCircle(screenCenter[0], screenCenter[1], hourHandWidth/2.0);
      dc.setColor(_theme["AccentColor"], _theme["HighPowerBackgroundColor"]);
      dc.fillCircle(screenCenter[0], screenCenter[1], hourHandBorder);    

  }

    function drawLowPowerWatchFace(dc as Dc, _theme as Dictionary<String, String or Number>) as Void {
      dc.setColor(_theme["LowPowerBackgroundColor"], _theme["LowPowerBackgroundColor"]);
      dc.clear();

      var dateTime = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
      var hourHandAngle = dateTime.hour % 12 * Math.PI / 6 + dateTime.min * Math.PI / 360;
      var minuteHandAngle = dateTime.min * Math.PI / 30;
      var affineTransform = new Graphics.AffineTransform();

      //Draw marks
        for (var i = 0; i < 60; i++) {
          affineTransform.setToTranslation(screenCenter[0], screenCenter[1]);
          affineTransform.rotate(i * Math.PI / 30);
          dc.setColor(_theme["LowPowerMarksColor"], _theme["LowPowerBackgroundColor"]);
          if (i == 0 || i == 15 || i == 30 || i == 45) {
            dc.fillPolygon(affineTransform.transformPoints(marks12Polygon));
            dc.setColor(_theme["LowPowerBackgroundColor"], _theme["LowPowerBackgroundColor"]);
            dc.fillPolygon(affineTransform.transformPoints(marks60Polygon));
          } else if (i % 5 == 0) {
            dc.fillPolygon(affineTransform.transformPoints(marks12Polygon));
            dc.setColor(_theme["LowPowerBackgroundColor"], _theme["LowPowerBackgroundColor"]);
            dc.fillPolygon(affineTransform.transformPoints(marks60Polygon));
          }
        }

        //Draw hour hand
        affineTransform.setToTranslation(screenCenter[0], screenCenter[1]);
        affineTransform.rotate(hourHandAngle);
        dc.setColor(_theme["LowPowerHandsColor"], _theme["LowPowerBackgroundColor"]);
        dc.fillPolygon(affineTransform.transformPoints(hourHandInnerPolygon));

        //Draw minute hand
        affineTransform.setToTranslation(screenCenter[0], screenCenter[1]);
        affineTransform.rotate(minuteHandAngle);
        dc.setColor(_theme["LowPowerHandsColor"], _theme["LowPowerBackgroundColor"]);
        dc.fillPolygon(affineTransform.transformPoints(minuteHandInnerPolygon));
    }

    //TODO : Cleanup when Complications are implemented
    function handleClickEvent(clickEvent as ClickEvent) as Void {
        if (System.getDisplayMode() == System.DISPLAY_MODE_HIGH_POWER) {
            for (var i = 0; i <= 7; i++) {
              if (isPoint2DInArea(clickEvent.getCoordinates(), _complicationsAreas[i])) {
                switch (_complications[i]) {
                  case instanceof String:
                    //TODO : Strings
                    break;
                  case 100:
                    Complications.exitTo(new Complications.Id(Complications.COMPLICATION_TYPE_CALENDAR_EVENTS)); //HACK > No System exitTo() fot DATE compilations
                    break;
                  default:
                    break;
                }
                i = 8;
              } else {
                continue;
              }
            }
        }
    }

    function isPoint2DInArea(point2D as Point2D, area as Area?) as Boolean {
      if (area == null) {
        return false;
      }
      return point2D[0] >= area[0] && point2D[0] <= area[0] + area[2] &&
             point2D[1] >= area[1] && point2D[1] <= area[1] + area[3];
    }
}
