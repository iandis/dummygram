
class IPopup{
  inform(context, String message, { int duration = 3000}){}
  error(context, String message, {int duration = 3000}){}
  warning(context, String message, {int duration = 3000}){}
  custom(context, String message, textColor, backgroundColor, {int duration = 3000}){}
}