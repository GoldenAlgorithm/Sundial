import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SundialWatchFace extends WatchUi.WatchFace {

  private var _screenRadius as Float = SundialSettings.getScreenWidth() <= SundialSettings.getScreenHeight() ? SundialSettings.getScreenWidth() / 2.0 : SundialSettings.getScreenHeight() / 2.0;
  private var _screenCenter_X_Y as [Float, Float] = [_screenRadius, _screenRadius];
  
  //Watch Face (all scales are based on _screenRradius)
  private const _MARK60_WIDTH_SCALE                  as Float = 0.01;
  private const _MARK60_LENGTH_SCALE                 as Float = 0.05;
  private const _MARK12_WIDTH_SCALE_TO_MARK60        as Float = 2.00;
  private const _MARK12_LENGTH_SCALE_TO_MARK60       as Float = 1.50;
  private const _MARK4_WIDTH_SCALE_TO_MARK60         as Float = 3.00;
  private const _MARK4_LENGTH_SCALE_TO_MARK60        as Float = 1.75;
  private const _HOUR_HAND_WIDTH_SCALE               as Float = 0.10;
  private const _HOUR_HAND_LENGTH_SCALE              as Float = 0.55;
  private const _HOUR_HAND_ACCENT_WIDTH_SCALE        as Float = _HOUR_HAND_WIDTH_SCALE * 0.30;
  private const _MINUTE_HAND_WIDTH_SCALE             as Float = _HOUR_HAND_WIDTH_SCALE;
  private const _MINUTE_HAND_LENGTH_SCALE            as Float = 0.90;
  private const _MINUTE_HOUR_HAND_ACCENT_WIDTH_SCALE as Float = _MINUTE_HAND_WIDTH_SCALE * 0.30;
  private const _SECOND_HAND_WIDTH_SCALE             as Float = 0.02;
  private const _SECOND_HAND_LENGTH_SCALE            as Float = _MINUTE_HAND_LENGTH_SCALE;
  private const _SECOND_HAND_TIP_LENGTH_SCALE        as Float = 0.15;
  private const _CENTER_INNER_RADIUS_SCALE           as Float = _HOUR_HAND_ACCENT_WIDTH_SCALE >= _MINUTE_HOUR_HAND_ACCENT_WIDTH_SCALE ? _HOUR_HAND_ACCENT_WIDTH_SCALE : _MINUTE_HOUR_HAND_ACCENT_WIDTH_SCALE;
  private const _CENTER_RADIUS_SCALE                 as Float = _HOUR_HAND_WIDTH_SCALE >= _MINUTE_HAND_WIDTH_SCALE ? _HOUR_HAND_WIDTH_SCALE / 2.00 : _MINUTE_HAND_WIDTH_SCALE / 2.00;
  private const _CENTER_OUTER_RADIUS_SCALE           as Float = _CENTER_RADIUS_SCALE * 1.75;

  // Polygons
  // Marks
  private var _mark60Polygon              as Array<Point2D>;
  private var _mark12Polygon              as Array<Point2D>;
  private var _mark4Polygon               as Array<Point2D>;
  // Hour hand
  private var _hourHandLeftSidePolygon    as Array<Point2D>;
  private var _hourHandRightSidePolygon   as Array<Point2D>;
  private var _hourHandInnerPolygon       as Array<Point2D>;
  // Minute hand
  private var _minuteHandLeftSidePolygon  as Array<Point2D>;
  private var _minuteHandRightSidePolygon as Array<Point2D>;
  private var _minuteHandInnerPolygon     as Array<Point2D>;
  // Second hand
  private var _secondHandPolygon as Array<Point2D>;
  private var _secondHandTipPolygon as Array<Point2D>;
  
  // Complications TODO

  //Modes
  private var _isInHighPowerMode as Boolean;
  
  function initialize() {

    WatchFace.initialize();

    var affineTransform = new Graphics.AffineTransform();

    // Marks
    _mark60Polygon = [
      [-_screenRadius * _MARK60_WIDTH_SCALE / 2.0, 0],
      [-_screenRadius * _MARK60_WIDTH_SCALE / 2.0, _screenRadius * _MARK60_LENGTH_SCALE],
      [ _screenRadius * _MARK60_WIDTH_SCALE / 2.0, _screenRadius * _MARK60_LENGTH_SCALE],
      [ _screenRadius * _MARK60_WIDTH_SCALE / 2.0, 0]];
    affineTransform.setToScale(_MARK12_WIDTH_SCALE_TO_MARK60, _MARK12_LENGTH_SCALE_TO_MARK60);
    _mark12Polygon = affineTransform.transformPoints(_mark60Polygon);
    affineTransform.setToScale(_MARK4_WIDTH_SCALE_TO_MARK60, _MARK4_LENGTH_SCALE_TO_MARK60);
    _mark4Polygon = affineTransform.transformPoints(_mark60Polygon);
    affineTransform.setToTranslation(0.0, -_screenRadius);
    _mark60Polygon = affineTransform.transformPoints(_mark60Polygon);
    _mark12Polygon = affineTransform.transformPoints(_mark12Polygon);
    _mark4Polygon = affineTransform.transformPoints(_mark4Polygon);

    // Complications TODO
    
    // Hour hand
    _hourHandLeftSidePolygon = [
      [0.0, 0.0],
      [-_screenRadius * _HOUR_HAND_WIDTH_SCALE / 2.0, 0.0],
      [-_screenRadius * _HOUR_HAND_WIDTH_SCALE / 2.0, -_screenRadius * _HOUR_HAND_LENGTH_SCALE + _screenRadius * _HOUR_HAND_WIDTH_SCALE / 2.0],
      [0.0, -_screenRadius * _HOUR_HAND_LENGTH_SCALE]];
    _hourHandRightSidePolygon = [
      [0.0, 0.0],
      [_screenRadius * _HOUR_HAND_WIDTH_SCALE / 2.0, 0.0],
      [_screenRadius * _HOUR_HAND_WIDTH_SCALE / 2.0, -_screenRadius * _HOUR_HAND_LENGTH_SCALE + _screenRadius * _HOUR_HAND_WIDTH_SCALE / 2.0],
      [0.0, -_screenRadius * _HOUR_HAND_LENGTH_SCALE]];
    _hourHandInnerPolygon = [
      [-_screenRadius * _HOUR_HAND_WIDTH_SCALE / 2.0 + _screenRadius * _HOUR_HAND_ACCENT_WIDTH_SCALE, -_screenRadius * _HOUR_HAND_WIDTH_SCALE - _screenRadius * _HOUR_HAND_ACCENT_WIDTH_SCALE],
      [-_screenRadius * _HOUR_HAND_WIDTH_SCALE / 2.0 + _screenRadius * _HOUR_HAND_ACCENT_WIDTH_SCALE, -_screenRadius * _HOUR_HAND_LENGTH_SCALE + _screenRadius * _HOUR_HAND_WIDTH_SCALE / 2.0 + _screenRadius * _HOUR_HAND_ACCENT_WIDTH_SCALE],
      [ _screenRadius * _HOUR_HAND_WIDTH_SCALE / 2.0 - _screenRadius * _HOUR_HAND_ACCENT_WIDTH_SCALE, -_screenRadius * _HOUR_HAND_LENGTH_SCALE + _screenRadius * _HOUR_HAND_WIDTH_SCALE / 2.0 + _screenRadius * _HOUR_HAND_ACCENT_WIDTH_SCALE],
      [ _screenRadius * _HOUR_HAND_WIDTH_SCALE / 2.0 - _screenRadius * _HOUR_HAND_ACCENT_WIDTH_SCALE, -_screenRadius * _HOUR_HAND_WIDTH_SCALE - _screenRadius * _HOUR_HAND_ACCENT_WIDTH_SCALE]];
  
    // Minute hand
    _minuteHandLeftSidePolygon = [
      [0.0, 0.0],
      [-_screenRadius * _MINUTE_HAND_WIDTH_SCALE / 2.0, 0.0],
      [-_screenRadius * _MINUTE_HAND_WIDTH_SCALE / 2.0, -_screenRadius * _MINUTE_HAND_LENGTH_SCALE + _screenRadius * _MINUTE_HAND_WIDTH_SCALE / 2.0],
      [0.0, -_screenRadius * _MINUTE_HAND_LENGTH_SCALE]];
    _minuteHandRightSidePolygon = [
      [0.0, 0.0],
      [_screenRadius * _MINUTE_HAND_WIDTH_SCALE / 2.0, 0.0],
      [_screenRadius * _MINUTE_HAND_WIDTH_SCALE / 2.0, -_screenRadius * _MINUTE_HAND_LENGTH_SCALE + _screenRadius * _MINUTE_HAND_WIDTH_SCALE / 2.0],
      [0.0, -_screenRadius * _MINUTE_HAND_LENGTH_SCALE]];
    _minuteHandInnerPolygon = [
      [-_screenRadius * _MINUTE_HAND_WIDTH_SCALE / 2.0 + _screenRadius * _MINUTE_HOUR_HAND_ACCENT_WIDTH_SCALE, -_screenRadius * _MINUTE_HAND_WIDTH_SCALE - _screenRadius * _MINUTE_HOUR_HAND_ACCENT_WIDTH_SCALE],
      [-_screenRadius * _MINUTE_HAND_WIDTH_SCALE / 2.0 + _screenRadius * _MINUTE_HOUR_HAND_ACCENT_WIDTH_SCALE, -_screenRadius * _MINUTE_HAND_LENGTH_SCALE + _screenRadius * _MINUTE_HAND_WIDTH_SCALE / 2.0 + _screenRadius * _MINUTE_HOUR_HAND_ACCENT_WIDTH_SCALE],
      [ _screenRadius * _MINUTE_HAND_WIDTH_SCALE / 2.0 - _screenRadius * _MINUTE_HOUR_HAND_ACCENT_WIDTH_SCALE, -_screenRadius * _MINUTE_HAND_LENGTH_SCALE + _screenRadius * _MINUTE_HAND_WIDTH_SCALE / 2.0 + _screenRadius * _MINUTE_HOUR_HAND_ACCENT_WIDTH_SCALE],
      [ _screenRadius * _MINUTE_HAND_WIDTH_SCALE / 2.0 - _screenRadius * _MINUTE_HOUR_HAND_ACCENT_WIDTH_SCALE, -_screenRadius * _MINUTE_HAND_WIDTH_SCALE - _screenRadius * _MINUTE_HOUR_HAND_ACCENT_WIDTH_SCALE]];
  
    // Second hand
    _secondHandPolygon = [
      [-_screenRadius * _SECOND_HAND_WIDTH_SCALE / 2.0, 0.0],
      [-_screenRadius * _SECOND_HAND_WIDTH_SCALE / 2.0, -_screenRadius * _SECOND_HAND_LENGTH_SCALE + _screenRadius * _SECOND_HAND_TIP_LENGTH_SCALE],
      [ _screenRadius * _SECOND_HAND_WIDTH_SCALE / 2.0, -_screenRadius * _SECOND_HAND_LENGTH_SCALE + _screenRadius * _SECOND_HAND_TIP_LENGTH_SCALE],
      [ _screenRadius * _SECOND_HAND_WIDTH_SCALE / 2.0, 0.0]];
    _secondHandTipPolygon = [
      [-_screenRadius * _SECOND_HAND_WIDTH_SCALE / 2.0, -_screenRadius * _SECOND_HAND_LENGTH_SCALE + _screenRadius * _SECOND_HAND_TIP_LENGTH_SCALE],
      [-_screenRadius * _SECOND_HAND_WIDTH_SCALE / 2.0, -_screenRadius * _SECOND_HAND_LENGTH_SCALE + _screenRadius * _SECOND_HAND_WIDTH_SCALE / 2.0],
      [0, -_screenRadius * _SECOND_HAND_LENGTH_SCALE],
      [_screenRadius * _SECOND_HAND_WIDTH_SCALE / 2.0, -_screenRadius * _SECOND_HAND_LENGTH_SCALE + _screenRadius * _SECOND_HAND_WIDTH_SCALE / 2.0],
      [_screenRadius * _SECOND_HAND_WIDTH_SCALE / 2.0, -_screenRadius * _SECOND_HAND_LENGTH_SCALE + _screenRadius * _SECOND_HAND_TIP_LENGTH_SCALE]];
    
    _isInHighPowerMode = System.getDisplayMode() == System.DISPLAY_MODE_HIGH_POWER;

  }

  function onLayout(dc as Dc) as Void {

    dc.setAntiAlias(true);

  }

  function onUpdate(dc as Dc) as Void {
        
    var theme = SundialSettings.getCurrentTheme();
        
    clearScrean(dc, theme);
    if (_isInHighPowerMode) {
        drawHighPowerWatchFace(dc, theme);
    } else {
        drawLowPowerWatchFace(dc, theme);
    }

  }

  function onExitSleep() as Void {

    _isInHighPowerMode = true;

  }

  function onEnterSleep() as Void {

    _isInHighPowerMode = false;

  }

  function clearScrean(dc as Dc, theme as Dictionary<String, String or Number>) as Void {
    
    if (_isInHighPowerMode) {
        dc.setColor(theme["HighPowerBackgroundColor"], theme["HighPowerBackgroundColor"]);
    } else {
        dc.setColor(theme["LowPowerBackgroundColor"], theme["LowPowerBackgroundColor"]);
    }
    dc.clear();

  }

  function drawHighPowerWatchFace(dc as Dc, theme as Dictionary<String, String or Number>) as Void {

    var time = System.getClockTime();	
    var hourHandAngle = time.hour % 12 * Math.PI / 6 + time.min * Math.PI / 360;
    var isHourHandRight = hourHandAngle >= 0.0 && hourHandAngle < Math.PI;
    var minuteHandAngle = time.min * Math.PI / 30;
    var isMinuteHandRight = minuteHandAngle >= 0.0 && minuteHandAngle < Math.PI;
    var secondHandAngle = time.sec * Math.PI / 30;

    var affineTransform = new Graphics.AffineTransform();

    //Draw marks
    for (var i = 0; i < 60; i++) {
      affineTransform.setToTranslation(_screenCenter_X_Y[0], _screenCenter_X_Y[1]);
      affineTransform.rotate(i * Math.PI / 30.0);
      dc.setColor(theme["HighPowerMarksColor"], theme["HighPowerBackgroundColor"]);
      if (i == 0 || i == 15 || i == 30 || i == 45) {
        dc.fillPolygon(affineTransform.transformPoints(_mark4Polygon));
      } else if (i % 5 == 0) {
        dc.fillPolygon(affineTransform.transformPoints(_mark12Polygon));
      } else {
        dc.fillPolygon(affineTransform.transformPoints(_mark60Polygon));
      }
    }

    //Draw hour hand
    affineTransform.setToTranslation(_screenCenter_X_Y[0], _screenCenter_X_Y[1]);
    affineTransform.rotate(hourHandAngle);
    if (isHourHandRight) {
      dc.setColor(theme["HighPowerHandsLightColor"], theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(_hourHandLeftSidePolygon));
      dc.setColor(theme["HighPowerHandsDarkColor"], theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(_hourHandRightSidePolygon));
    } else {
      dc.setColor(theme["HighPowerHandsDarkColor"], theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(_hourHandLeftSidePolygon));
      dc.setColor(theme["HighPowerHandsLightColor"], theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(_hourHandRightSidePolygon));
    }
    dc.setColor(theme["AccentColor"], theme["HighPowerBackgroundColor"]);
    dc.fillPolygon(affineTransform.transformPoints(_hourHandInnerPolygon));

    //Draw minute hand
    affineTransform.setToTranslation(_screenCenter_X_Y[0], _screenCenter_X_Y[1]);
    affineTransform.rotate(minuteHandAngle);
    if (isMinuteHandRight) {
      dc.setColor(theme["HighPowerHandsLightColor"], theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(_minuteHandLeftSidePolygon));
      dc.setColor(theme["HighPowerHandsDarkColor"], theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(_minuteHandRightSidePolygon));
    } else {
      dc.setColor(theme["HighPowerHandsDarkColor"], theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(_minuteHandLeftSidePolygon));
      dc.setColor(theme["HighPowerHandsLightColor"], theme["HighPowerBackgroundColor"]);
      dc.fillPolygon(affineTransform.transformPoints(_minuteHandRightSidePolygon));
    }
    dc.setColor(theme["AccentColor"], theme["HighPowerBackgroundColor"]);
    dc.fillPolygon(affineTransform.transformPoints(_minuteHandInnerPolygon));
    
    //Draw second hand
    affineTransform.setToTranslation(_screenCenter_X_Y[0], _screenCenter_X_Y[1]);
    affineTransform.rotate(secondHandAngle);
    dc.setColor(theme["AccentColor"], theme["HighPowerBackgroundColor"]);
    dc.fillPolygon(affineTransform.transformPoints(_secondHandTipPolygon));
    dc.setColor(theme["HighPowerSecondHandColor"], theme["HighPowerBackgroundColor"]);
    dc.fillPolygon(affineTransform.transformPoints(_secondHandPolygon));
    
    //Draw center circle
    dc.setColor(theme["HighPowerBackgroundColor"], theme["HighPowerBackgroundColor"]);
    dc.fillCircle(_screenCenter_X_Y[0], _screenCenter_X_Y[1], _screenRadius * _CENTER_OUTER_RADIUS_SCALE);
    dc.setColor(theme["HighPowerSecondHandColor"], theme["HighPowerBackgroundColor"]); //TODO > Second hand color?? Maybe cleanup colors
    dc.fillCircle(_screenCenter_X_Y[0], _screenCenter_X_Y[1], _screenRadius * _CENTER_RADIUS_SCALE);
    dc.setColor(theme["AccentColor"], theme["HighPowerBackgroundColor"]);
    dc.fillCircle(_screenCenter_X_Y[0], _screenCenter_X_Y[1], _screenRadius * _CENTER_INNER_RADIUS_SCALE);

  }

  function drawLowPowerWatchFace(dc as Dc, theme as Dictionary<String, String or Number>) as Void {

    var time = System.getClockTime();	
    var hourHandAngle = time.hour % 12 * Math.PI / 6 + time.min * Math.PI / 360;
    var minuteHandAngle = time.min * Math.PI / 30;

    var affineTransform = new Graphics.AffineTransform();

    //Draw marks
    for (var i = 0; i < 60; i++) {
      affineTransform.setToTranslation(_screenCenter_X_Y[0], _screenCenter_X_Y[1]);
      affineTransform.rotate(i * Math.PI / 30.0);
      dc.setColor(theme["LowPowerMarksColor"], theme["LowPowerBackgroundColor"]);
      if (i % 5 == 0) {
        dc.fillPolygon(affineTransform.transformPoints(_mark12Polygon));
      }
    }

    //Draw hour hand
    affineTransform.setToTranslation(_screenCenter_X_Y[0], _screenCenter_X_Y[1]);
    affineTransform.rotate(hourHandAngle);
    dc.setColor(theme["LowPowerHandsColor"], theme["LowPowerBackgroundColor"]);
    dc.fillPolygon(affineTransform.transformPoints(_hourHandInnerPolygon));

    //Draw minute hand
    affineTransform.setToTranslation(_screenCenter_X_Y[0], _screenCenter_X_Y[1]);
    affineTransform.rotate(minuteHandAngle);
    dc.setColor(theme["LowPowerHandsColor"], theme["LowPowerBackgroundColor"]);
    dc.fillPolygon(affineTransform.transformPoints(_minuteHandInnerPolygon));
        
  }

  function handleClickEvent(clickEvent as ClickEvent) as Void {
  }

}
