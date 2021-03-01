//БИТ.AKU.29.01.2021 ->  
Служебный = Параметры.Объект.Служебный; 
Если НЕ Служебный 
	И Параметры.Объект.Вид_контрагента <> ПараметрыАлгоритма.Предприниматель Тогда 
//<- 
 
	//БИТ.AKU.29.01.2021 ->  
	//Проверка КПП (а заодно и ИНН перед изменением вида котрагента      
	// Если ИНН или КПП кривые, то ничего не делаем 
	ЭтоИностранныйКонтрагент 	= Параметры.Объект.Страна_Регистрации <> Справочники.СтраныМира.Россия; // Может быть незаполненным   
	   
	ДанныеКонтрагента = Новый Структура;   
	ДанныеКонтрагента.Вставить("ИНН",                СокрЛП(Параметры.Объект.ИНН));   
	ДанныеКонтрагента.Вставить("КПП",                СокрЛП(Параметры.Объект.КПП));   
	ДанныеКонтрагента.Вставить("Дата",               Неопределено);   
	ДанныеКонтрагента.Вставить("Состояние",          ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустаяСсылка"));   
	ДанныеКонтрагента.Вставить("ЭтоЮридическоеЛицо", БИТ_АлгоритмыСервер.ЭтоЮрЛицо(Параметры.Объект.Вид_контрагента));   
	ДополнительныеПараметрыПроверки = Неопределено;   
 
	Отказ = Ложь;   
	//БИТ.AKU.31.01.2021 ->  
	//Если НЕ ЭтоИностранныйКонтрагент Тогда     
	//<-  
		Отказ = ПроверкаКонтрагентовКлиентСервер.НайденыОшибкиВДанных(   
			ДанныеКонтрагента,   
			ТекущаяДатаСеанса(),   
			ДополнительныеПараметрыПроверки);   
		   
		Если Отказ  
			И ЗначениеЗаполнено(СокрЛП(Параметры.Объект.КПП)) Тогда   
			//Форма.СтатусПроверкиФНС = ДанныеКонтрагента.Состояние;   
			Сообщить(Строка(ДанныеКонтрагента.Состояние));    
		КонецЕсли;   
	//КонецЕсли;   
	Параметры.Вставить("Отказ", Отказ); 
 
	Если НЕ Отказ Тогда 
	//<-  
 
		//БИТ.AKU.13.01.2021 ->        
		// Проверка на Обособленное подразделение по КПП        
		Строка5_6 = Сред(СокрЛП(ОбъектОбработки),5,2);        
		Если Строка5_6 = "43"        
			ИЛИ Строка5_6 = "02"        
			ИЛИ Строка5_6 = "03" Тогда        
			НовыйВид_контрагента = ПараметрыАлгоритма.Филиал;        
		ИначеЕсли Строка5_6 = "45"        
			ИЛИ Строка5_6 = "31"        
			ИЛИ Строка5_6 = "32" Тогда        
			НовыйВид_контрагента = ПараметрыАлгоритма.Подразделение;        
		//БИТ.AKU.10.12.2020 ->       
		//ИначеЕсли ЗначениеЗаполнено(Параметры.Объект.Головной_контрагент)    
		//	И СокрЛП(ОбъектОбработки) = Параметры.Объект.Головной_контрагент.КПП Тогда    
		//	НовыйВид_контрагента = ПараметрыАлгоритма.ЮрЛицо;       
		//Иначе    
		//	НовыйВид_контрагента = неопределено;       
		Иначе    
			НовыйВид_контрагента = ПараметрыАлгоритма.ЮрЛицо;       
		//<-   
		КонецЕсли;        
		        
		Если (НовыйВид_контрагента = ПараметрыАлгоритма.Филиал     
			ИЛИ НовыйВид_контрагента = ПараметрыАлгоритма.Подразделение)     
			И НовыйВид_контрагента <> Параметры.Объект.Вид_контрагента Тогда        
			БИТ_АлгоритмыСервер.ПреобразоватьвОПилиФилиал(Параметры.Форма, Параметры.Объект, НовыйВид_контрагента, Истина);        
			Сообщить("Вид контрагента был изменен на " + НовыйВид_контрагента + " по результату проверки КПП");        
		ИначеЕсли НовыйВид_контрагента = ПараметрыАлгоритма.ЮрЛицо   
			И НовыйВид_контрагента <> Параметры.Объект.Вид_контрагента Тогда     
			БИТ_АлгоритмыСервер.ПреобразоватьвОПилиФилиал(Параметры.Форма, Параметры.Объект, НовыйВид_контрагента, Ложь);        
			Сообщить("Вид контрагента был изменен на ""Юридическое лицо"" по результату проверки КПП");        
		КонецЕсли;        
		//<-      
		//<- 							    
	КонецЕсли;	 
КонецЕсли;	 
		      
// Проверка на КПП по ФНС и вывод статуса 
ЦветТекстаКрасный	= Новый Цвет(255, 40, 0);        
ЦветТекстаЗеленый 	= Новый Цвет(51, 153, 102);        
ЦветТекстаСерый		= Новый Цвет(127, 127, 127);        
        
Если Параметры.Объект.Вид_контрагента <> ПараметрыАлгоритма.Предприниматель         
	И Параметры.Объект.Вид_контрагента <> ПараметрыАлгоритма.ФизЛицо    
	И Параметры.Объект.Страна_Регистрации = Справочники.СтраныМира.Россия 
	И НЕ Служебный Тогда    
//	Если ЗначениеЗаполнено(Параметры.Объект.ИНН)         
//		И ЗначениеЗаполнено(Параметры.Объект.КПП) Тогда         
		Параметры.Объект.СтатусПроверкиФНС = ПроверкаКонтрагентов.СостояниеКонтрагента(Параметры.Объект.ИНН, Параметры.Объект.КПП, ТекущаяДатаСеанса());          
		Параметры.Форма.СтатусПроверкиФНС = ПроверкаКонтрагентов.СостояниеКонтрагента(Параметры.Объект.ИНН, Параметры.Объект.КПП, ТекущаяДатаСеанса());          
		Если Параметры.Объект.СтатусПроверкиФНС = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НеДействуетИлиИзмененКПП") Тогда          
			Параметры.Форма.Элементы.СтатусПроверкиФНС.ЦветТекста = ЦветТекстаСерый;          
		ИначеЕсли Параметры.Объект.СтатусПроверкиФНС = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентЕстьВБазеФНС") Тогда          
			Параметры.Форма.Элементы.СтатусПроверкиФНС.ЦветТекста = ЦветТекстаЗеленый;          
		Иначе          
			Параметры.Форма.Элементы.СтатусПроверкиФНС.ЦветТекста = ЦветТекстаКрасный;          
		КонецЕсли;          
//	Иначе	         
//		Параметры.Объект.СтатусПроверкиФНС = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустойИННИлиКПП");          
//		Параметры.Форма.Элементы.СтатусПроверкиФНС.ЦветТекста = ЦветТекстаКрасный;          
//	КонецЕсли;          
	Параметры.Форма.Элементы.СтатусПроверкиФНС.Видимость = Истина;           
Иначе	         
	Параметры.Объект.СтатусПроверкиФНС = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустойИННИлиКПП");          
	Параметры.Форма.СтатусПроверкиФНС = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустойИННИлиКПП");          
	Параметры.Форма.Элементы.СтатусПроверкиФНС.Видимость = Ложь;           
КонецЕсли;          
		      
//Параметры.ИзменятьДанные = Истина;          
Параметры.ОбновлятьОтображение = Истина;        

