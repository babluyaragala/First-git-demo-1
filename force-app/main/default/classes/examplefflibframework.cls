public class examplefflibframework
{}
    /*
    /**

 * @description This class is used to create a factory for our application we are working on. Basically
 * it allows you to send in an object type (or something similar) to have different classes returned to you.


public with sharing class Application
{
	//This creates a Unit of Work for your application. The objects in the List<SObject> need to be in order of insertion.
	//If you insert cases first put it at the top of the list, etc.
	//Exmaple initialization: fflib_ISObjectUnitOfWork unitOfWork = Application.UOW.newInstance();
	public static final fflib_Application.UnitOfWorkFactory UOW =
		new fflib_Application.UnitOfWorkFactory(
			new List<SObjectType>{
			Account.SObjectType,
			Contact.SObjectType,
			Case.SObjectType,
			Task.SObjectType}
	);

	//This allows us to create a factory for instantiating service classes. You send it the interface for your service class
	//and it will return the correct service layer class
	//Exmaple initialization: Object objectService = Application.service.newInstance(Task_Service_Interface.class);
	public static final fflib_Application.ServiceFactory service =
			new fflib_Application.ServiceFactory(
					new Map<Type, Type>{
							Task_Service_Interface.class => Task_Service_Impl.class}
			);

	public static final fflib_Application.ServiceFactory serviceByRecordType =
			new fflib_Application.ServiceFactory(
					new Map<String, Type>{
							'B2B Sales Case' => Help_Desk_B2B_Service_Impl.class,
							'B2C Sales Case' => Help_Desk_B2C_Service_Impl.class,
					        'Marketing Case' => Help_Desk_Marketing_Service_Impl.class}
			);

	//This allows us to create a factory for instantiating selector classes. You send it an object type and it sends
	//you the corresponding selectory layer class.
	//Exmaple initialization: fflib_ISObjectSelector objectSelector = Application.selector.newInstance(objectType);
	public static final fflib_Application.SelectorFactory selector =
			new fflib_Application.SelectorFactory(
					new Map<SObjectType, Type>{
							Case.SObjectType => Case_Selector.class,
							Contact.SObjectType => Contact_Selector.class,
							Task.SObjectType => Task_Selector.class,
							Account.SObjectType => Account_Selector.class}
			);

	//This allows you to create a factory for instantiating domain classes. You can send it a set of record ids and
	//you'll get the corresponding domain layer.
	//Example initialization: fflib_ISObjectDomain objectDomain = Application.domain.newInstance(recordIds);
	public static final fflib_Application.DomainFactory domain =
			new fflib_Application.DomainFactory(
					Application.selector,
					new Map<SObjectType, Type>{Case.SObjectType => Cases.Constructor.class,
					Contact.SObjectType => Contacts.Constructor.class,
					Account.SObjectType => Accounts.Constructor.class}
			);


}
    /**
 
 * @description This class is used to select data from the case object. It's the only place that case object queries
 * should be made
 

//We extend the fflib_SObjectSelector class to gain access to its many useful prebuilt methods
//We extend the Task_Selector_Interface to force it to implement a particular set of methods to help with abstraction
//in the Task_Service_Impl class
//
public inherited sharing class Case_Selector extends fflib_SObjectSelector implements Task_Selector_Interface
{
	//This sets the base fields that you will ALWAYS have in your queries when calling this selector class
	public List<Schema.SObjectField> getSObjectFieldList(){
		return new List<Schema.SObjectField>{
			Case.Id,
			Case.Subject,
			Case.Status,
			Case.ContactId
		};
	}

	//This will return your object type for this selector, useful in abstractions
	public Schema.SObjectType getSObjectType(){
		return Case.SObjectType;
	}

	//This method calls the fflib_SObjectSelector classes selectSObjectsById method and returns a list
	//of cases from the caseIds you sent in with the default fields declared in the getSObjectFieldList method above
	public List<Case> selectById(Set<Id> caseIds){
		return (List<Case>) selectSObjectsById(caseIds);
	}

	//This uses the fflib_SObjectSelector class's QueryFactory inner class to create a custom query with
	//extra fields selected and conditions set
	public List<Case> selectCaseByAccount(Set<Id> acctIds){
		return (List<Case>) Database.query(
			newQueryFactory().
					selectField(Case.AccountId).
					setCondition('AccountId IN :acctIds').
					toSOQL()
		);
	}

	//This allows us to select all new cases in the system using the QueryFactory in fflib_SObjectSelector
	public List<Case> selectNewCases(){
		return (List<Case>) Database.query(newQueryFactory().
				setCondition('Status = \'New\'').setLimit(1000).subselectQuery(Contact).
				toSOQL());
	}

	//This method HAS TO BE IMPLEMENTED since we are implementing the Task_Selector_Interface in this class
	//It queries for records and adds fields specific for this query
	public List<Case> selectRecordsForTasks()
	{
		return (List<SObject>) Database.query(
				newQueryFactory().
						selectField(Case.Origin).
						toSOQL()
		);
	}

	public List<Case> innerQueryExample(){
		fflib_QueryFactory caseQueryFactory = newQueryFactory();
		fflib_QueryFactory taskSubSelectQuery = new Task_Selector().addQueryFactorySubselect(caseQueryFactory);
		System.debug('This is the query ::: ' + caseQueryFactory.toSOQL());
		return (List<Case>) Database.query(caseQueryFactory.toSOQL());
	}
}
    public interface Case_Selector_Interface
{

}
    
 /**
 * Created by gerry on 3/21/2021.
 

public inherited sharing class Cases extends fflib_SObjectDomain implements Task_Creator_Interface
{
	//This sets up the super class (fflib_SObjectDomain) to have the records variable filled out
	public Cases(List<Case> caseRecords){
		super(caseRecords);
		Cases.getTriggerEvent(Cases.class).disableBeforeInsert();
	}

	//This helps allow for the fflib_SObjectDomain class to run its triggerHandler method
	//using the correct Domain class. This must be implemented in all domain classes.
	public class Constructor implements fflib_SObjectDomain.IConstructable{
		public fflib_SObjectDomain construct(List<SObject> sObjectList){
			return new Cases(sObjectList);
		}
	}

	//This method is called on a beforeInsert transaction to set defaults on a record
	public override void onApplyDefaults(){
		//The records variable comes from the super class
		for(Case newCase: (List<Case>) Records){
			if(newCase.Status == 'New'){
				newCase.Status = 'Open';
			}
		}
	}

	//This method is called on an afterInsert transaction to make sure all validations are being checked
	//before the record is officially committed to the database.
	public override void onValidate()
	{
		for(Case newCase : (List<Case>) records)
		{
			if(newCase.ContactId == null)
			{
				//throw new Cases_Exception();
			}
		}
	}

	public void createTasks(List<SObject> recordsToCreateTasksFor, fflib_ISObjectUnitOfWork unitOfWork)
	{
		List<Case> caseList = (List<Case>) recordsToCreateTasksFor;
		List<Task> taskList = new List<Task>();
		for(Case cs: caseList){
			Task tsk = new Task();
			tsk.Status = 'New';
			tsk.Subject = cs.Origin + cs.Subject;
			tsk.WhoId = cs.ContactId;
			tsk.ActivityDate = Date.today();
			taskList.add(tsk);
		}
		unitOfWork.registerNew(taskList);
	}
}
    trigger Cases on Case (before insert, before update, after insert, after update)
{
	fflib_SObjectDomain.triggerHandler(Cases.class);
}
public with sharing class Cases_Exception extends Exception
{
	public override String getMessage(){
		return 'All cases must have contacts associated with them';
	}
}
    
/**
 * Created by gerry on 3/29/2021.
 

public inherited sharing class Contact_Selector extends fflib_SObjectSelector
{
	public Contact_Selector(){
		super(false, true, true, false);
	}

	public List<Schema.SObjectField> getSObjectFieldList(){
		return new List<Schema.SObjectField>{
				Contact.Id,
				Contact.Name,
				Contact.FirstName,
				Contact.LastName
		};
	}

	public Schema.SObjectType getSObjectType(){
		return Contact.SObjectType;
	}

	public List<Contact> selectById(Set<Id> contactIds){
		return (List<Contact>) selectSObjectsById(contactIds);
	}
}

/**
 * @author Matt Gerry
 * @date 3/29/2021
 * @description This is the Domain Layer class for the Contact object. It extends the fflib_SObjectDomain so that we can
 * inherit the many useful pre-built functionality in it. It extends the Task_Creator_Interface to force this class into a
 * contract and make it implement the methods in that contract. It helps with abstraction in the Task_Service_Impl class
 

public inherited sharing class Contacts extends fflib_SObjectDomain implements Task_Creator_Interface
{
	//This sets up the super class (fflib_SObjectDomain) to have the records variable filled out
	public Contacts(List<Contact> contactRecords){
		super(contactRecords);
	}

	//This helps allow for the fflib_SObjectDomain class to run its triggerHandler method
	//using the correct Domain class. This must be implemented in all domain classes.
	public class Constructor implements fflib_SObjectDomain.IConstructable{
		public fflib_SObjectDomain construct(List<SObject> sObjectList){
			return new Contacts(sObjectList);
		}
	}

	//This method MUST BE IMPLEMENTED due to this class implementing the Task_Selector_Interface interface. It creates new tasks
	//and registers them in a new unit of work to be committed to the database at a later time.
	public fflib_ISObjectUnitOfWork createTasks(List<SObject> recordsToCreateTasksFor, fflib_ISObjectUnitOfWork unitOfWork)
	{
		List<Contact> contList = (List<Contact>) recordsToCreateTasksFor;
		List<Task> taskList = new List<Task>();
		for(Contact cont: contList){
			Task tsk = new Task();
			tsk.Status = 'New';
			tsk.Subject = cont.Name;
			tsk.WhoId = cont.Id;
			tsk.ActivityDate = Date.today();
			taskList.add(tsk);
		}
		unitOfWork.registerNew(taskList);
		return unitOfWork;
	}
}

/*
   @author: Matt Gerry
   @date: 04/11/2021
   @description: This class is an override for the prebuilt fflib_Application.ServiceFactory that allows
   us to dynamically call service classes based on the running users custom permissions.
 

public with sharing class ServiceFactory extends fflib_Application.ServiceFactory
{
	Map<String, Service_By_User_Type__mdt> servicesByUserPermAndInterface = new Map<String, Service_By_User_Type__mdt>();
	Map<String, Type> servicesByRecordType = new Map<String, Type>();

	public ServiceFactory(Map<Type, Type> serviceInterfaceByServiceImpl){
		super(serviceInterfaceByServiceImpl);
		this.servicesByUserPermAndInterface = getServicesByUserPermAndInterface();
	}

	public ServiceFactory(Map<String, Type> servicesByRecordType){
		super(servicesByRecordType);
		this.servicesByRecordType = servicesByRecordType;
	}

	public Object newInstanceByRecordType(String RecordType){
		Type serviceImpl = servicesByRecordType.get(RecordType);
		if(serviceImpl==null)
			throw new fflib_Application.DeveloperException('No implementation registered for record type ' + RecordType);
		return serviceImpl.newInstance();
	}

	//Overriding the fflib_Application.ServiceFactory newInstance method to allow us to initialize a new service implementation type based on the running
	//users custom permissions and the interface name passed in.
	public override Object newInstance(Type serviceInterfaceType){
		for(Service_By_User_Type__mdt serviceByUser: servicesByUserPermAndInterface.values()){
			if(servicesByUserPermAndInterface.containsKey(serviceByUser.User_Permission__c + serviceInterfaceType)){
				Service_By_User_Type__mdt overrideClass = servicesByUserPermAndInterface.get(serviceByUser.User_Permission__c + serviceInterfaceType.getName());
				return Type.forName(overrideClass.Service_Implementation_Class__c).newInstance();
			}
		}
		return super.newInstance(serviceInterfaceType);
	}

	//Creating our map of overrides by our user custom permissions
	private Map<String, Service_By_User_Type__mdt> getServicesByUserPermAndInterface(){
		Map<String, Service_By_User_Type__mdt> servicesByUserType = new Map<String, Service_By_User_Type__mdt>();
		for(Service_By_User_Type__mdt serviceByUser: Service_By_User_Type__mdt.getAll().values()){
			//Checking to see if running user has any of the permissions for our overrides, if so we put the overrides in a map
			if(FeatureManagement.checkPermission(serviceByUser.User_Permission__c)){
				servicesByUserType.put(serviceByUser.User_Permission__c + serviceByUser.Service_Interface__c, serviceByUser);
			}
		}
		return servicesByUserType;
	}
}
public interface Task_Creator_Interface
{
	fflib_ISObjectUnitOfWork createTasks(List<SObject> recordsToCreateTasksFor, fflib_ISObjectUnitOfWork unitOfWork);
}
    
/**
 * Created by gerry on 3/29/2021.
 

public with sharing class Task_Selector extends fflib_SObjectSelector
{
	public Task_Selector(){
		super(false, true, true, false);
	}

	public List<Schema.SObjectField> getSObjectFieldList(){
		return new List<Schema.SObjectField>{
				Task.Id,
				Task.Subject,
				Task.WhatId,
				Task.WhoId
		};
	}

	public Schema.SObjectType getSObjectType(){
		return Task.SObjectType;
	}

	public List<Task> selectById(Set<Id> taskIds){
		return (List<Task>) selectSObjectsById(taskIds);
	}

	public List<Task> selectTodaysTasks(){
		Date todaysDate = Date.today();
		return (List<SObject>) Database.query(
				newQueryFactory().
						setCondition('ActivityDate = :todaysDate').
						toSOQL()
		);
	}
}
public interface Task_Selector_Interface
{
	List<SObject> selectRecordsForTasks();
}
    
/**
 * @author Matt Gerry
 * @date 03/30/2021
 * @description This task service class is implemented this way for two reasons, potential abstraction and for unit
 * test mocking. Basically for every method in your service class (in this case Task_Service_Impl) you
 * should have an equivalent method in here that calls that method in your true service class implementation.
 

global with sharing class Task_Service
{
	//This literally just calls the Task_Service_Impl class's createTasks method
	global static void createTasks(Set<Id> recordIds, Schema.SObjectType objectType){
		service().createTasks(recordIds, objectType);
	}

	//This gets an instance of the Task_Service_Impl class from our Application class
	private static Task_Service_Interface service(){
		return (Task_Service_Interface) Application.service.newInstance(Task_Service_Interface.class);
	}
}

/**
 * @author Matt Gerry
 * @date 03/30/2021
 * @description This is the true implementation of your business logic for your service layer. These impl classes
 * are where all the magic happens. In this case this is a service class that executes the business logic for Abstract
 * Task creation on any theoretical object.
 

public with sharing class Task_Service_Impl implements Task_Service_Interface
{
	//This method creates tasks and MUST BE IMPLEMENTED since we are implementing the Task_Service_Interface
	public void createTasks(Set<Id> recordIds, Schema.SObjectType objectType)
	{
		//Getting a new instance of a domain class based purely on the ids of our records, if these were case
		//ids it would return a Case object domain class, if they were contacts it would return a contact
		//object domain class
		fflib_ISObjectDomain objectDomain = Application.domain.newInstance(recordIds);

		//Getting a new instance of our selector class based purely on the object type passed. If we passed in a case
		//object type we would get a case selector, a contact object type a contact selector, etc.
		fflib_ISObjectSelector objectSelector = Application.selector.newInstance(objectType);

		//We're creating a new unit of work instance from our Application class.
		fflib_ISObjectUnitOfWork unitOfWork = Application.UOW.newInstance();

		//List to hold our records that need tasks created for them
		List<SObject> objectsThatNeedTasks = new List<SObject>();

		//If our selector class is an instance of Task_Selector_Interface (if it implement the Task_Selector_Interface
		//interface) call the selectRecordsForTasks() method in the class. Otherwise just call the selectSObjectsById method
		if(objectSelector instanceof Task_Selector_Interface){
			Task_Selector_Interface taskFieldSelector = (Task_Selector_Interface) objectSelector;
			objectsThatNeedTasks = taskFieldSelector.selectRecordsForTasks();

			if(objectsThatNeedTasks instanceof List<Case>){
				for(SObject cs: objectsThatNeedTasks){
					cs.put('Subject', 'Bye');
				}
				unitOfWork.registerDirty(objectsThatNeedTasks);
			}

		}
		else{
			System.debug('Selector not an instance of tsi');
			objectsThatNeedTasks = objectSelector.selectSObjectsById(recordIds);
		}

		//If our domain class is an instance of the Task_Creator_Interface (or implements the Task_Creator_Interface class)
		//call the createTasks method
		if(objectDomain instanceof Task_Creator_Interface){
			System.debug('Domain an instance of tci');
			Task_Creator_Interface taskCreator = (Task_Creator_Interface)objectDomain;
			taskCreator.createTasks(objectsThatNeedTasks, unitOfWork);
		}

		//Try commiting the records we've created and/or updated in our unit of work (we're basically doing all our DML at
		//once here), else throw an exception.
		try{
			unitOfWork.commitWork();
		}
		catch(Exception e){
			throw e;
		}
	}
}

/**
 * @description this is a test class for the Task_Service_Impl class. It is
 * an example showing how to leverage apex mocks with the apex common library.
 * @author Matt Gerry
 * @date 04/18/2021
 
@IsTest
public with sharing class Task_Service_Impl_Test
{
	@IsTest
	private static void createTasks_CasesSuccess_UnitTest(){
		//Creating a new fake case id using the IdGenerator class. We do this
		//to avoid unnecessary dml insert statements. Note how the same id is used everywhere.
		//make sure this id is consistent between your lists and sets you're passing
		//back and forth or you may run into some problems.
		Id mockCaseId = fflib_IDGenerator.generate(Case.SObjectType);

		//Creating a set of ids that we pass to our methods.
		Set<Id> caseIds = new Set<Id>{mockCaseId};
		//Creating the list of cases we'll return from our selector method
		List<Case> caseList = new List<Case>{new Case(Id = mockCaseId, Subject = 'Hi', Status = 'New', Origin = 'Email')};

		//Creating our mock class representations by using the ApexMocks class's mock method
		//and passing it the appropriate class type.
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_SObjectUnitOfWork mockUOW = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
		Cases mockCaseDomain = (Cases) mocks.mock(Cases.class);
		Case_Selector mockCaseSelector = (Case_Selector) mocks.mock(Case_Selector.class);

		//After you've setup your mocks above, we need to stub (or setup the expected
		//method calls and what they would return.
		mocks.startStubbing();
		//The sObjectType method in selector and domain classes is always called so it must
		//always be stubbed.
		mocks.when(mockCaseSelector.sObjectType()).thenReturn(Case.SObjectType);
		//If you are dynamically generating domain class instances by passing in a set of ids
		//the selectSObjectsById method is called so it must be stubbed.
		mocks.when(mockCaseSelector.selectSObjectsById(caseIds)).thenReturn(caseList);
		//This is the actual method in my select that gets called, so we definitely need
		//to stub it.
		mocks.when(mockCaseSelector.selectRecordsForTasks()).thenReturn(caseList);
		//The sObjectType method in selector and domain classes is always called so it must
		//always be stubbed.
		mocks.when(mockCaseDomain.sObjectType()).thenReturn(Case.SObjectType);
		//If you want to mock exceptions, this is the way to do it. Basically it works like this.
		//call the mocks.doThrownWhen method and pass it the exception you would like to throw and
		//the mock class that should throw it. Then wrap cast the whole mocks.doThrownWhen
		//method as the class type it should be (in this cass fflibSObjectUnitOfWork) and
		//call the method that should throw the error (in this case commitWork).
		((fflib_SObjectUnitOfWork)mocks.doThrowWhen(new DmlException(), mockUOW)).commitWork();
		//When you are done setting these up, DO NOT FORGET to call the stopStubbing method
		//or you're gonna waste hours of your life confused
		mocks.stopStubbing();

		//AFTER you do your stubbing, and ONLY AFTER, you set your mocks in your
		//application class (whatever you've named it). Then your code will leverage
		//the mock classes as opposed to the real classes
		Application.UOW.setMock(mockUOW);
		Application.domain.setMock(mockCaseDomain);
		Application.selector.setMock(mockCaseSelector);


		try{
			Test.startTest();
			//Calling the method we're actually testing (this is a real method call)
			Task_Service.createTasks(caseIds, Case.SObjectType);
			Test.stopTest();
		}
		catch(Exception e){
			//Because we are throwing an exception in our stubs we need to wrap our real
			//method call in a try catch and figure out whether or not it actually threw the
			//exception we anticipated it throwing.
			System.assert(e instanceof DmlException);
		}

		//Verifying this method was never called, we didn't intend to call it, so
		//just checking we didn't
		((Cases)mocks.verify(mockCaseDomain, mocks.never().description('This method was called but it shouldn\'t have been'))).handleAfterInsert();
		List<Case> caseMatchingList = (List<Case>)fflib_Match.sObjectsWith(new List<Map<Schema.SObjectField, Object>>{new Map<SObjectField, Object>{
				Case.Id => mockCaseId,
				Case.Subject => 'Bye',
				Case.Status => 'New',
				Case.Origin => 'Email'
		}});

		((fflib_ISObjectUnitOfWork)mocks.verify(mockUOW, 1)).registerDirty(caseMatchingList);
		((fflib_ISObjectUnitOfWork)mocks.verify(mockUOW,1)).registerDirty(caseList);
		((Cases)mocks.verify(mockCaseDomain, 1)).createTasks(caseList, mockUOW);
		//Checking that we did indeed call the createTasks method as expected.
		//((Cases)mocks.verify(mockCaseDomain)).createTasks(caseMatchingList, (fflib_ISObjectUnitOfWork)fflib_Match.anyObject());
	}
}

/**
 * @author Matt Gerry
 * @date 03/30/2021
 * @description To help with unit test mocking and with abstraction we need to produce this interface. For every single
 * public method that you create in your Task_Service_Impl class you need to represent it here.
 

public interface Task_Service_Interface
{
	void createTasks(Set<Id> recordIds, Schema.SObjectType objectType);
}


}
*/