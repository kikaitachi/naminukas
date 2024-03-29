local defaultOptions = {
  { "ControlX", SOURCE, 1 },
  { "ScrollZ", BOOL, 1 }, -- BOOL is actually not a boolean, but toggles between 0 and 1
  { "StepZ", VALUE, 1, 0, 10},
  { "COLOR", COLOR, RED },
}

local function createWidget(zone, options)
  lcd.setColor( CUSTOM_COLOR, options.COLOR )
  --  the CUSTOM_COLOR is foreseen to have one color that is not radio template related, but it can be used by other widgets as well!
  local someVariable = 0
  local anotherVariable = {xWidget=0, yWidget = 0}
  return { zone=zone, options=options , someVariable = someVariable, anotherVariable=anotherVariable }
end

local function updateWidget(widgetToUpdate, newOptions)
  widgetToUpdate.options = newOptions
  lcd.setColor( CUSTOM_COLOR, widgetToUpdate.options.COLOR )
  --  the CUSTOM_COLOR is foreseen to have one color that is not radio template related, but it can be used by other widgets as well!
end

local function backgroundProcessWidget(widgetToProcessInBackground)
  local function process(...)
          return ... + 1
        end
  widgetToProcessInBackground.someVariable = process (widgetToProcessInBackground.someVariable)
end

local function refreshWidget(widgetToRefresh)
  lcd.setColor(CUSTOM_COLOR, 0x11E0)  -- Dark green
  lcd.drawFilledRectangle(0, 0, LCD_W, LCD_H, CUSTOM_COLOR)
  lcd.setColor(CUSTOM_COLOR, WHITE)

  local counterLength = 50
  local counterHeight = 30

  --backgroundProcessWidget(widgetToRefresh)
  --background is not called automatically in display mode, so do it here if you need it.

  local function anotherProcess(parameter,step,maxParameter)
          return (parameter + step) % maxParameter
        end

  widgetToRefresh.anotherVariable.xWidget
    = anotherProcess ( widgetToRefresh.anotherVariable.xWidget
      ,getValue(widgetToRefresh.options.ControlX)/10.24/20
      ,widgetToRefresh.zone.w-counterLength)

  widgetToRefresh.anotherVariable.yWidget
    = anotherProcess ( widgetToRefresh.anotherVariable.yWidget
      ,(widgetToRefresh.options.ScrollZ==1) and widgetToRefresh.options.StepZ or 0
      ,widgetToRefresh.zone.h-counterHeight)

  local value = -1
  local fieldInfo = getFieldInfo('5100')
  if fieldInfo then
    local id = fieldInfo.id
    value = getValue(id)
    sportTelemetryPush(id, 0x10, 0x5100, 0x12345678)
  end

  lcd.drawNumber(widgetToRefresh.anotherVariable.xWidget + widgetToRefresh.zone.x
    , widgetToRefresh.anotherVariable.yWidget + widgetToRefresh.zone.y
    , value
    , LEFT + DBLSIZE + CUSTOM_COLOR);
  lcd.drawText(0, 0, "Bot: " .. 11.23 .. "V Trans: " .. math.floor(getValue("tx-voltage") * 100) / 100 .. "V", LEFT + SMLSIZE)
  lcd.drawText(LCD_W, 0, "Mode: tracks*", RIGHT + SMLSIZE + CUSTOM_COLOR)
end

return {
  name="naminukas",
  options=defaultOptions,
  create=createWidget,
  update=updateWidget,
  refresh=refreshWidget,
  background=backgroundProcessWidget
}
