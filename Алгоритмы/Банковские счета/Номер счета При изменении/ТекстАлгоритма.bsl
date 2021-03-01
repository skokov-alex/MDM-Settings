ОбъектОбработки = СтрЗаменить(ОбъектОбработки, " ", "");

ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Форма.Банк,"Код,СВИФТБИК,Страна");

ЯвляетсяБанкомРФ = (ЗначенияРеквизитов.Страна = Справочники.СтраныМира.Россия);
Если ЯвляетсяБанкомРФ Тогда 
	БИКБанка = ЗначенияРеквизитов.Код;
Иначе
	БИКБанка = ЗначенияРеквизитов.СВИФТБИК;
КонецЕсли;

ЦветТекстаКрасный = Новый Цвет(255, 40, 0);
НомерСчетаКорректен = Ложь;
ПодсказкаНомерСчета = нсиБанковскиеСчетаФормыКлиентСервер.ПодсказкаПоляНомерСчета(
	ОбъектОбработки, БИКБанка, ЯвляетсяБанкомРФ, ЦветТекстаКрасный, НомерСчетаКорректен);
	
Если НомерСчетаКорректен И ЯвляетсяБанкомРФ Тогда
	Если нсиБанковскиеПравила.ЭтоРублевыйСчет(ОбъектОбработки) Тогда
		Параметры.Форма.ВалютаДенежныхСредств = Справочники.Валюты.НайтиПоКоду("643");
		Параметры.Форма.Валютный = Ложь;
	Иначе
		КодВалюты = нсиБанковскиеПравила.КодВалютыБанковскогоСчета(Параметры.Объект.НомерСчета);
		Параметры.Форма.ВалютаДенежныхСредств = нсиБанковскиеСчетаВызовСервера.ПолучитьВалютуПоКоду(КодВалюты);
		Параметры.Форма.Валютный = Истина;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Параметры.Форма.ВалютаДенежныхСредств) Тогда
		ТекстСообщения = Нстр("ru = 'Валюта счета неизвестна. Проверьте номер счета'");
		ПодсказкаНомерСчета = Новый ФорматированнаяСтрока(ТекстСообщения,, ЦветТекстаКрасный);
	КонецЕсли;
	
КонецЕсли;

Параметры.Форма.ПодсказкаНомерСчета = ПодсказкаНомерСчета;
Если ЗначениеЗаполнено(ПодсказкаНомерСчета) Тогда
	Параметры.Форма.Элементы.ПодсказкаНомерСчета.ЦветТекста = ЦветТекстаКрасный;
КонецЕсли;

Параметры.ОбновлятьОтображение = Истина;


