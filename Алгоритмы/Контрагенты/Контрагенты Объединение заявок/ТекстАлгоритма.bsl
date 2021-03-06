// >> 1БИТ, Скоков, 29.01.2021, Задача MDM-65
//
// Описание алгоритма:
// 		Алгоритм выполняет заполнение массива параметров,
//		которые необходимых для объединения заявок.
//
// Настройки алгоритма:
// 		Наименование			Контрагенты Объединение заявок
// 		Область применения		Объединение заявок
//
// Параметры передаваемые в алгоритм:
// 		ОбъектОбработки			- ДанныеФормыСтруктура структуру реквизитов создаваемого элемента справочника
// 		Параметры.МассивВариантовПоиска	- массив настройки поиска заявок для объединения
// 		Параметры.ЗаявкаОбъект	- БизнесПроцессОбъект.нсиЗаявкаНаИзменение - объект бизнес-процесса

КлючиПоиска = Новый Структура;
МетодыСравнения = Новый Структура;

ЭтоГруппа = Неопределено;
Если НЕ ОбъектОбработки.Свойство("ЭтоГруппа", ЭтоГруппа) Тогда
	ЭтоГруппа = Ложь;
КонецЕсли;

Если ЭтоГруппа Тогда
	КлючиПоиска.Вставить("ЭтоГруппа", ЭтоГруппа);
	КлючиПоиска.Вставить("Наименование", ОбъектОбработки.Наименование);
	МетодыСравнения.Вставить("ЭтоГруппа", "=");
	МетодыСравнения.Вставить("Наименование", "=");
ИначеЕсли ОбъектОбработки.Вид_контрагента.Наименование = "Индивидуальный предприниматель" Тогда
	КлючиПоиска.Вставить("ИНН", ОбъектОбработки.ИНН);
	КлючиПоиска.Вставить("СвидетельствоСерияНомер", ОбъектОбработки.СвидетельствоСерияНомер);
	КлючиПоиска.Вставить("СвидетельствоДатаВыдачи", ОбъектОбработки.СвидетельствоДатаВыдачи);
	МетодыСравнения.Вставить("ИНН", "=");
	МетодыСравнения.Вставить("СвидетельствоСерияНомер", "=");
	МетодыСравнения.Вставить("СвидетельствоДатаВыдачи", "=");
ИначеЕсли ОбъектОбработки.Вид_контрагента.Наименование = "Физическое лицо" Тогда
	КлючиПоиска.Вставить("Наименование", ОбъектОбработки.Наименование);
	КлючиПоиска.Вставить("ИНН", ОбъектОбработки.ИНН);
	МетодыСравнения.Вставить("Наименование", "=");
	МетодыСравнения.Вставить("ИНН", "=");
Иначе
	КлючиПоиска.Вставить("ИНН", ОбъектОбработки.ИНН);
	КлючиПоиска.Вставить("КПП", ОбъектОбработки.КПП);
	МетодыСравнения.Вставить("ИНН", "=");
	МетодыСравнения.Вставить("КПП", "=");
КонецЕсли;

ВариантПоиска = Новый Структура;
ВариантПоиска.Вставить("КлючиПоиска", КлючиПоиска);
ВариантПоиска.Вставить("МетодыСравнения", МетодыСравнения);

Параметры.МассивВариантовПоиска.Добавить(ВариантПоиска);
// << 1БИТ, Скоков, 29.01.2021, Задача MDM-65

