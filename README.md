# RAP Demo Setup Guide
Fiori Elements Demo App with ABAP Restful Application Programming Backend Service

## Choose a suffix
During this exercise you will use a suffix to prevent naming collisions. Everytime you see ## within the code snippets, please replace them by your suffix.

## Open ABAP Perspective in Eclipse
Open the ABAP Perspective in Eclipse by clicking "Window" -> "Perspective" -> "Open Perspective" -> "Other" -> "ABAP"

## Development Project
If not already there, create a new ABAP (Cloud) Project.

## Create your ABAP Package
Create a new ABAP package ZS_ERP_RAP_TRAINING_## to group the various development artefacts that you’re going to create during the greenfield implementation.

Go to the Project explorer, right-click on your package ZS_ERP_RAP_TRAINING and choose the context menu entry New > ABAP Package.

Maintain ZS_ERP_RAP_TRAINING_## as name and a meaningful description (e.g. Greenfield Implementation - Travel List Report App) and choose Next to continue.
The Project and the Superpackage fields are automatically assigned.

Select an existing transport dummy request then choose "Finish" to create the new package.

Right-click on the new created package and choose "Add to Favorites Packages" to add it to your favorites.

## Setup Database
### Step 1. Create the Travel Database Table  
You will now create the database table **`zsrap_trav_##`** to store the travel data.  
A Travel entity defines general travel data, such as the agency ID or customer ID, the status of the travel booking, and the price of travel.   

1. Right click on your package **`ZS_ERP_RAP_TRAINING_##`**, choose **_New > Other ABAP Repository Object_** from the context menu.
2. Enter `database` in the search field, choose **Database table** in the list and then choose **Next**.  
3. Maintain **`zsrap_trav_##`** as name and a meaningful description (e.g. _**Travel data**_) in the appearing dialog and choose **Next**.   
4. Assign a transport request and choose **Finish**.  
5. Replace the default source code with the code snippet provided below and replace all occurrences of  `######` with your chosen suffix.  
    You can make use of the Replace All feature (**Ctrl+F**) in ADT for the purpose.   
  
    <pre>
    @EndUserText.label : 'Travel data'
    @AbapCatalog.enhancementCategory : #NOT_EXTENSIBLE
    @AbapCatalog.tableCategory : #TRANSPARENT
    @AbapCatalog.deliveryClass : #A
    @AbapCatalog.dataMaintenance : #RESTRICTED
    define table zsrap_trav_## {
      key client            : mandt not null;
      key travel_uuid       : sysuuid_x16 not null;
      travel_id             : /dmo/travel_id;
      agency_id             : /dmo/agency_id;
      customer_id           : /dmo/customer_id;
      begin_date            : /dmo/begin_date;
      end_date              : /dmo/end_date;
      @Semantics.amount.currencyCode : 'zsrap_trav_##.currency_code'
      booking_fee           : /dmo/booking_fee;
      @Semantics.amount.currencyCode : 'zsrap_trav_##.currency_code'
      total_price           : /dmo/total_price;
      currency_code         : /dmo/currency_code;
      description           : /dmo/description;
      overall_status        : /dmo/overall_status;
      created_by            : syuname;
      created_at            : timestampl;
      last_changed_by       : syuname;
      last_changed_at       : timestampl;
      local_last_changed_at : timestampl;
    }
    </pre>
   

    **Short explanations:**  
    - Some data elements from the ABAP Flight Reference Scenario (namespace `/DMO/`) are used.  
    - The table key consists of the `CLIENT` field and the `TRAVEL_UUID` field which is a technical key (16 Byte UUID).   
    - A human-readable travel identifier: `TRAVEL_ID`  
    - The field CURRENCY_CODE is specified as currency key for the amount fields `BOOKING_FEE` and `TOTAL_PRICE` using the semantic annotation `@Semantics.amount.currencyCode`   
    - Some standard administrative fields are defined: `CREATED_BY`, `CREATED_AT`, `LAST_CHANGED_BY`, `LAST_CHANGED_AT` and `LOCAL_LAST_CHANGED_AT`.  
  
7. Save and activate the changes.  
  
8. Press **F8** to start the data preview.  

### Step 3. Create the Booking Database Table
You will now create the database table **`ZSRAP_BOOK_##`** (where `####` is your chosen suffix),  to store the booking data.   
A Booking entity comprises general flight and booking data, the customer ID for whom the flight is booked as well as the travel ID to which the booking belongs – and some admin fields.  
  
1. Right click on the **Database Tables** folder, choose **New Database Table** from the context menu.  
  
2. Maintain **`ZSRAP_BOOK_##`** as name and a meaningful description (e.g. _**Booking data**_) in the appearing dialog and choose **Next**. 
  
3.  Assign a transport request and choose **Finish**.  
  
4. Replace the default source code with the code snippet provided below and replace all occurrences of  `######` with your chosen suffix.   
    You can make use of the Replace All feature (shortcut **Ctrl+F**) in ADT for the purpose.  
  
    <pre> 
    @EndUserText.label : 'Booking data'
    @AbapCatalog.enhancementCategory : #NOT_EXTENSIBLE
    @AbapCatalog.tableCategory : #TRANSPARENT
    @AbapCatalog.deliveryClass : #A
    @AbapCatalog.dataMaintenance : #RESTRICTED
    define table zsrap_book_## {
      key client            : mandt not null;
      key booking_uuid      : sysuuid_x16 not null;
      travel_uuid           : sysuuid_x16 not null;
      booking_id            : /dmo/booking_id;
      booking_date          : /dmo/booking_date;
      customer_id           : /dmo/customer_id;
      carrier_id            : /dmo/carrier_id;
      connection_id         : /dmo/connection_id;
      flight_date           : /dmo/flight_date;
      @Semantics.amount.currencyCode : 'zsrap_book_##.currency_code'
      flight_price          : /dmo/flight_price;
      currency_code         : /dmo/currency_code;
      created_by            : syuname;
      last_changed_by       : syuname;
      local_last_changed_at : timestampl;
    }
    </pre>   
  
    **Short explanations:**
    - Some data elements from the ABAP Flight Reference Scenario (namespace /DMO/) are used.  
    - The table key consists of the `CLIENT` field and the `BOOKING_UUID` field which is a technical key (16 Byte UUID).   
    - A human-readable travel identifier: `BOOKING_ID`  
    - The field CURRENCY_CODE is specified as currency key for the amount field FLIGHT_PRICE using the semantic annotation `@Semantics.amount.currencyCode`.  
    - Some standard administrative fields are defined: `CREATED_BY`, `LAST_CHANGED_BY`, and `LOCAL_LAST_CHANGED_AT`.  
  
  6. Save and activate the changes.  
  
7. Press **F8** to start the data preview.   
    Well, the database table is empty for now, so no data is displayed.  
 

### Step 4. Fill in the Database Tables with Demo Data
You will now fill in the created travel and booking database tables with some demo data to ease the test. Demo data provided by the ABAP Flight Reference Scenario (main package: `/DMO/FLIGHT`) will be used for the purpose.   
  
1. Right click on your package **_ZRAP_TRAVEL_######** and choose **_New > ABAP Class_** from the context menu.      

2. Maintain **`ZSCL_GEN_DEMO_DATA_##`** as name and a meaningful description (e.g. _**Generate Travel and Booking demo data**_) in the creation wizard for the new ABAP class.  
    Add the ABAP interface **`IF_OO_ADT_CLASSRUN`** which needs to be implemented to write outputs to the ABAP Console and continue with **Next**.  

3. Assign a transport request and choose **Finish**.  
  
4. Insert the implementation of method **`if_oo_adt_classrun~main`**  with the code snippet provided below.
  
    <pre> 
    METHOD if_oo_adt_classrun~main.

    " delete existing entries in the database table
    DELETE FROM zsrap_trav_##.
    DELETE FROM zsrap_book_##.

    " insert travel demo data
    INSERT zsrap_trav_## FROM (
        SELECT
          FROM /dmo/travel
          FIELDS
            uuid(  )      AS travel_uuid           ,
            travel_id     AS travel_id             ,
            agency_id     AS agency_id             ,
            customer_id   AS customer_id           ,
            begin_date    AS begin_date            ,
            end_date      AS end_date              ,
            booking_fee   AS booking_fee           ,
            total_price   AS total_price           ,
            currency_code AS currency_code         ,
            description   AS description           ,
            CASE status
              WHEN 'B' THEN 'A' " accepted
              WHEN 'X' THEN 'X' " cancelled
              ELSE 'O'          " open
            END           AS overall_status        ,
            createdby     AS created_by            ,
            createdat     AS created_at            ,
            lastchangedby AS last_changed_by       ,
            lastchangedat AS last_changed_at       ,
            lastchangedat AS local_last_changed_at
            ORDER BY travel_id UP TO 200 ROWS
      ).
    COMMIT WORK.

    " insert booking demo data
    INSERT zsrap_book_## FROM (
        SELECT
          FROM   /dmo/booking    AS booking
            JOIN zsrap_trav_## AS z
            ON   booking~travel_id = z~travel_id
          FIELDS
            uuid( )                 AS booking_uuid          ,
            z~travel_uuid           AS travel_uuid           ,
            booking~booking_id      AS booking_id            ,
            booking~booking_date    AS booking_date          ,
            booking~customer_id     AS customer_id           ,
            booking~carrier_id      AS carrier_id            ,
            booking~connection_id   AS connection_id         ,
            booking~flight_date     AS flight_date           ,
            booking~flight_price    AS flight_price          ,
            booking~currency_code   AS currency_code         ,
            z~created_by            AS created_by            ,
            z~last_changed_by       AS last_changed_by       ,
            z~last_changed_at       AS local_last_changed_by
      ).
    COMMIT WORK.

    out->write( 'Travel and booking demo data inserted.').
    ENDMETHOD.
    </pre>

    **Short explanations:**  
    - First, any existing entries in both database tables are deleted.  
    - Then the data is selected from the tables `/DMO/TRAVEL` and `/DMO/BOOKING` and inserted into your tables `ZSRAP_ATRAV_##` and `ZSRAP_BOOK_##` respectively.  
    - The SQL function `UUID( )` is used to set the value of the key fields `TRAVEL_UUID` and `BOOKING_UUID`.   
    - The `COMMIT WORK` statement is then executed to persist the data. The data selection has been limited to up to 200 travel records, but you can change this if desired.  
    - A success message is written to the Console at the end.  
  
5. Save and activate the changes.  
  
6. Press **F9** to run the ABAP class as a console application to generate the demo data and and fill your tables.
  
7. Now you can preview the data from the Travel and Booking database tables.  
    Choose the relevant database table in the Project Explorer and press **F8**.  
        
    The Data Preview will open in the editor area.

## CDS Business Object Definition
### Step 1.	Create the Interface CDS View for the Travel Entity
First, create the Interface CDS view **`ZS_I_TRAV_##`** for the Travel entity 

1. Right-click on your travel table **`ZSRAP_TRAV_##`** and choose **New Data Definition** from the context menu.

2.  Maintain **`ZS_I_TRAV_##`** as name and a meaningful description (e.g. _**Travel BO view**_) in the creation wizard and choose **Next** to continue.  

3. Assign a transport request and choose **Next**. 
  
4. Choose the **Define View entity** template from the list of Data Definition templates provided for your convenience and then choose **Finish**.

5. Replace the code of the travel data definition in the editor (after the define view statement) with the code snippet provided below and replace all occurrences of  `##` with your chosen suffix. 

    <pre>
      association [0..1] to /DMO/I_Agency       as _Agency   on $projection.AgencyID = _Agency.AgencyID
      association [0..1] to /DMO/I_Customer     as _Customer on $projection.CustomerID = _Customer.CustomerID
      association [0..1] to I_Currency          as _Currency on $projection.CurrencyCode = _Currency.Currency  
    {
      key travel_uuid           as TravelUUID,
          travel_id             as TravelID,
          agency_id             as AgencyID,
          customer_id           as CustomerID,
          begin_date            as BeginDate,
          end_date              as EndDate,
          @Semantics.amount.currencyCode: 'CurrencyCode'
          booking_fee           as BookingFee,
          @Semantics.amount.currencyCode: 'CurrencyCode'
          total_price           as TotalPrice,
          currency_code         as CurrencyCode,
          description           as Description,
          overall_status        as TravelStatus,
          @Semantics.user.createdBy: true
          created_by            as CreatedBy,
          @Semantics.systemDateTime.createdAt: true
          created_at            as CreatedAt,
          @Semantics.user.lastChangedBy: true
          last_changed_by       as LastChangedBy,
          @Semantics.systemDateTime.lastChangedAt: true
          last_changed_at       as LastChangedAt,
          @Semantics.systemDateTime.localInstanceLastChangedAt: true
          local_last_changed_at as LocalLastChangedAt,

          /* calculated fields */
       
          concat_with_space ( _Customer.FirstName, _Customer.LastName, 1 ) as CustomerName, 

          /* associations */
          _Agency,
          _Customer,
          _Currency      
    }
    </pre>

   6. Define an Alias for the travel view by adding "as Travel" after the view entity defintion statement. 

### Step 2.	Create the Interface CDS View for the Booking entity
Now, you will create the Interface CDS view **`ZS_I_BOOK_##`** for the Booking entity.
1. Right-click on your booking table **`ZSRAP_BOOK_##`** and choose **New Data Definition** from the context menu.

2.  Maintain **`ZS_I_BOOK_##`** as name and a meaningful description (e.g. _**Booking BO view**_) in the creation wizard and choose **Next** to continue.  

3. Assign a transport request and choose **Next**. 
 
4. Choose the Define View entity template from the list and then choose **Finish**.

5. Replace the booking data definition in the editor after the define view entity statement with the code snippet provided below and replace all occurrences of  `##` with your chosen suffix. You can make use of the _Replace All_ feature (**Ctrl+F**) in ADT for the purpose. 

    <pre>      
      association [1..1] to /DMO/I_Customer           as _Customer   on  $projection.CustomerID   = _Customer.CustomerID
      association [1..1] to /DMO/I_Carrier            as _Carrier    on  $projection.CarrierID    = _Carrier.AirlineID
      association [1..1] to /DMO/I_Connection         as _Connection on  $projection.CarrierID    = _Connection.AirlineID
                                                                     and $projection.ConnectionID = _Connection.ConnectionID
      association [1..1] to /DMO/I_Flight             as _Flight     on  $projection.CarrierID    = _Flight.AirlineID
                                                                     and $projection.ConnectionID = _Flight.ConnectionID
                                                                     and $projection.FlightDate   = _Flight.FlightDate
      association [0..1] to I_Currency                as _Currency   on $projection.CurrencyCode    = _Currency.Currency    
    {
      key booking_uuid          as BookingUUID,
          travel_uuid           as TravelUUID,
          booking_id            as BookingID,
          booking_date          as BookingDate,
          customer_id           as CustomerID,
          carrier_id            as CarrierID,
          connection_id         as ConnectionID,
          flight_date           as FlightDate,
          @Semantics.amount.currencyCode: 'CurrencyCode'
          flight_price          as FlightPrice,
          currency_code         as CurrencyCode,
          @Semantics.user.createdBy: true
          created_by            as CreatedBy,
          @Semantics.user.lastChangedBy: true
          last_changed_by       as LastChangedBy,
          @Semantics.systemDateTime.localInstanceLastChangedAt: true
          local_last_changed_at as LocalLastChangedAt,

          /* associations */
          _Customer,
          _Carrier,
          _Connection,
          _Flight,
          _Currency
    }
    </pre>

  6. Define an Alias for the travel view by adding "as Booking" after the view entity defintion statement. 

### Step 3.	Activate the CDS Data Model & Preview the Data 
To avoid an error during the activation, both new CDS views – i.e. the Travel interface view and the Booking interface view – must be activated together for the first time.  

1.	Choose **Activate All** and select both CDS views **`ZS_I_TRAV_##`** and **`ZS_I_BOOK_##`** on the appearing dialog, and choose **Activate**.

### Step 4.	Define the Composition Model

1.	Open the CDS data definition **`ZS_I_TRAV_##`**  and add the keyword **`root`**  in the **`define view entity`** statement to change it as follows:
    <pre>
      define root view entity ZS_I_TRAV_##
    </pre>

2.	Add an definition for the the **`_Booking`** as a composition which is needed to define the relationship from a parent node (travel) to a child node (booking). 
For that, add the following composition definition to **`ZS_I_TRAV_##`**:  
    <pre>
       composition [0..*] of ZI_RAP_BOOK_###### as _Booking 
    </pre>

And add the _Booking association into the curly brackets.

3.	Save the changes, but **DO NOT** yet activate the changes. 

4.	Now open the CDS data definition **`ZS_I_BOOK_##`** and add the definition of the association **`_Travel`** with the definition provided below to specify the relationship from the child node (_booking_) to its parent node (_travel_). 

    <pre>
      association to parent ZI_RAP_TRAV_######        as _Travel     on  $projection.TravelUUID = _Travel.TravelUUID
    </pre>

And add the _Travel assocation into the curly brackets.

5.	Save the changes and activate **BOTH** CDS views together by choosing **Activate All** selecting both CDS views in the appearing dialog and choosing **Activate**.

## CDS Projection Views
### Step 1. Create the Travel Projection View

First, create the Travel BO projection view (aka consumption view) **`ZS_C_TRAV_##`** for the Travel entity.

1. Right-click on your travel view (aka interface view) **`ZS_I_TRAV_##`** and choose **New Data Definition** from the context menu.

2.  Maintain **`ZS_C_TRAV_##`** as name and a meaningful description (e.g. _**Travel BO projection view**_) in the creation wizard and choose **Next >** to continue.   
The project, the package and the referenced object have been automatically assigned in the creation wizard. 

3. Assign a transport request and choose **Next >**.  

4. Choose the **`Define Projection View`** template from the list and then choose **Finish**.

5. Replace the travel data definition in the editor with the code snippet provided below and replace all occurrences of **`##`** with your chosen suffix. 

    <pre>
    @EndUserText.label: 'Travel BO projection view'
    @AccessControl.authorizationCheck: #NOT_REQUIRED
    @Search.searchable: true
    @Metadata.allowExtensions: true

    define root view entity ZS_C_TRAV_##
      as projection on ZS_I_TRAV_## as Travel
    {
      key TravelUUID,
          @Search.defaultSearchElement: true
          TravelID,
          @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Agency', element: 'AgencyID'} }]
          @ObjectModel.text.element: ['AgencyName']
          @Search.defaultSearchElement: true
          AgencyID,
          _Agency.Name       as AgencyName,
          @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer', element: 'CustomerID'} }]
          @ObjectModel.text.element: ['CustomerName']
          @Search.defaultSearchElement: true
          CustomerID,
          CustomerName,
          BeginDate,
          EndDate,
          @Semantics.amount.currencyCode: 'CurrencyCode'
          BookingFee,
          @Semantics.amount.currencyCode: 'CurrencyCode'
          TotalPrice,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency'} }]
          CurrencyCode,
          Description,
          TravelStatus,
          LastChangedAt,
          LocalLastChangedAt,

          /* Associations */
          _Agency,
          _Booking : redirected to composition child ZS_C_BOOK_##,
          _Currency,
          _Customer   
    }
    </pre>
    
    **Short explanation: What has changed?**
    - The alias **`Travel`** is specified for the projected view
    - The keyword **`root`** is specified in the **`DEFINE`** statement to specify the projected Travel BO as root node.
    - The view annotations **`@Metadata.allowedExtension`** is specified before the **`DEFINE`** statement to allow the projection view to be enhanced with separate metadata extensions 
    - The view annotations **`@Search.Searchable`** is specified before the **`DEFINE`** statement to allow the projection view to enable the full-text (aka freestyle) search.
    - The freestyle search is enabled for the view elements **`TravelID`**, **`AgencyID`** and **`CustomerID`** using the annotation **`@Search.DefaultSearchElement`**.
    - The view elements **`AgencyName`** from the association **`_Agency`** and **`CustomerName`** from the association **`_Customer`** have been added to the projection list.
    They are specified as  textual description for the view elements **`AgencyID`** and **`CustomerID`** respectively using the **`@ObjectModel.text.element`** annotation.
    - Value helps are specified for the view elements **`AgencyID`**, **`CustomerID`**, and **`CurrencyCode`** using the annotation **`@Consumption.valueHelpDefinition`**. 
    The name of the target CDS entity that acts as a value help provider and the name of its element that is linked to the local element have to be specified. 
    - The view element **`CurrencyCode`** is specified as the reference field for the currency fields **`BookingFee`** and **`TotalPrice`** using the **`@Semantics.amount.currencyCode`**  annotations. 
    - The view elements **`CreatedBy`**, **`CreatedAt`** and **`LastChangedBy`** have been removed from the projection list because they only have an are administrative function and will be of no use in our scenario. The view elements **`LastChangedAt`** and **`LocalLastChangedAt`** remain in the projection list because they will be used for the transactional enablement of Your Travel List Report App in week 3 – especially for the implementation of the optimistic lock.
    - associations have been exposed in the projection list
    - association to the booking BO child node (**`_Booking`**) has been redirected to the appropriate Booking BO projection view using the **`redirected to composition child`**  statement.    
         
    
### Step 2. Create the Booking Projection View
Now, you will create the missing Booking BO projection view (aka consumption view) **`ZS_C_BOOK_##`** for the Booking entity.

1. Right-click on your Booking BO view (aka interface view) **`ZS_I_BOOK_##`** and choose **New Data Definition** from the context menu.

2.  Maintain **`ZS_C_BOOK_##`** as name and a meaningful description (e.g. _**Booking BO projection view**_) in the creation wizard and choose **Next >** to continue.  
    The project, the package and the referenced object have been automatically assigned in the creation wizard.  

3. Assign a transport request and choose **Next >**. 

4. Choose the **`Define Projection View`** template from the list and then choose **Finish**.

5. Replace the booking data definition in the editor with the code snippet provided below and replace all occurrences of **`##`** with your chosen suffix. 
    
    <pre>
    @EndUserText.label: 'Booking BO projection view'
    @AccessControl.authorizationCheck: #NOT_REQUIRED
    @Search.searchable: true
    @Metadata.allowExtensions: true

    define view entity ZS_C_BOOK_##
      as projection on ZS_I_BOOK_## as Booking
    {
      key BookingUUID,
          TravelUUID,
          @Search.defaultSearchElement: true
          BookingID,
          BookingDate,
          @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Customer', element: 'CustomerID'  } }]
          @ObjectModel.text.element: ['CustomerName']
          @Search.defaultSearchElement: true
          CustomerID,
          _Customer.LastName as CustomerName,
          @Consumption.valueHelpDefinition: [{entity: {name: '/DMO/I_Carrier', element: 'AirlineID' }}]
          @ObjectModel.text.element: ['CarrierName']
          CarrierID,
          _Carrier.Name      as CarrierName,
          @Consumption.valueHelpDefinition: [ {entity: {name: '/DMO/I_Flight', element: 'ConnectionID'},
                                               additionalBinding: [ { localElement: 'CarrierID',    element: 'AirlineID' },
                                                                    { localElement: 'FlightDate',   element: 'FlightDate',   usage: #RESULT},
                                                                    { localElement: 'FlightPrice',  element: 'Price',        usage: #RESULT },
                                                                    { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT } ] } ]
          ConnectionID,
          FlightDate,
          @Semantics.amount.currencyCode: 'CurrencyCode'
          FlightPrice,
          @Consumption.valueHelpDefinition: [{entity: {name: 'I_Currency', element: 'Currency' }}]
          CurrencyCode,
          LocalLastChangedAt,

          /* associations */
          _Travel : redirected to parent ZS_C_TRAV_##,
          _Customer,
          _Carrier,
          _Connection,
          _Flight
    }
    </pre>


### Step 3. Activate the CDS Data Model Projection & Run the Data Preview 
To avoid error during the activation, both new CDS interface views – i.e. Travel view and Booking view – must be activated together for the first time.  

1.	Choose **`Activate All`** or use the shortcut **Ctrl+Shift+F3**.    
    Select both CDS views **`ZS_C_TRAV_##`** and **`ZS_C_BOOK_##`** on the appearing dialog, and choose **Activate**.

## Metadata Extensions
### Step 1. Annotate the Travel Projection View
First, create the CDS metadata extensions **`ZS_C_TRAV_##`** to enrich the Travel BO projection view with UI semantics.

1.	Right-click on your Travel BO projection view **`ZS_C_TRAV_##`** in the Project Explorer and select **New Metadata Extension** from the context menu.

2.	Maintain **`ZS_C_TRAV_##`** as name and a meaningful description (e.g. _**UI Annotations for `ZS_C_TRAV_##`**_) and choose _**Next >**_ to continue.    

3.	Assign a transport request and choose **Next >**.  

4.	Metadata extension templates are provided for your convenience. Choose the **annotate view** template and choose **Finish**.

5.	Specify the metadata layer at the top of the extension as follows   
**` @Metadata.layer: #CORE`** .  

6.	Now, you can specify the UI annotations for the remaining elements.   
    For that, replace the code in the editor with the code snippet provided below and replace all occurrences of  `##` with your chosen suffix.   
        
    <pre>
    @Metadata.layer: #CORE
    @UI: {
      headerInfo: { typeName: 'Travel',
                    typeNamePlural: 'Travels',
                    title: { type: #STANDARD, label: 'Travel', value: 'TravelID' } },
      presentationVariant: [{ sortOrder: [{ by: 'TravelID', direction:  #DESC }] }] }

    annotate view ZS_C_TRAV_## with
    {
      @UI.facet: [ { id:              'Travel',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Travel',
                     position:        10 },
                   { id:              'Booking',
                     purpose:         #STANDARD,
                     type:            #LINEITEM_REFERENCE,
                     label:           'Booking',
                     position:        20,
                     targetElement:   '_Booking'} ]  

      @UI:{ identification: [{ position: 1, label: 'Travel UUID' }] }
      TravelUUID;

      @UI: {  lineItem:       [ { position: 10 } ],
              identification: [ { position: 10 } ],
              selectionField: [ { position: 10 } ] }  
      TravelID;

      @UI: {  lineItem:       [ { position: 20 } ],
              identification: [ { position: 20 } ],
              selectionField: [ { position: 20 } ] }  
      AgencyID;

      @UI: {  lineItem:       [ { position: 30 } ],
              identification: [ { position: 30 } ],
              selectionField: [ { position: 30 } ] }  
      CustomerID;

      @UI: {  lineItem:       [ { position: 40 } ],
              identification: [ { position: 40 } ] }  
      BeginDate;

      @UI: {  lineItem:       [ { position: 50 } ],
              identification: [ { position: 50 } ] }   
      EndDate;

      @UI: {  lineItem:       [ { position: 60 } ],
              identification: [ { position: 60 } ] }   
      BookingFee;

      @UI: {  lineItem:       [ { position: 70 } ],
              identification: [ { position: 70 } ] }   
      TotalPrice;

      @UI: {  lineItem:       [ { position: 80 } ],
              identification: [ { position: 80 } ] }   
      Description;

      @UI: {  lineItem:       [ { position: 90 } ],
              identification: [ { position: 90 } ] }   
      TravelStatus;

      @UI.hidden: true
      LastChangedAt;

      @UI.hidden: true
      LocalLastChangedAt;
    }
    </pre>

7.	Save and activate the changes.  


### Step 2. Annotate the Booking Projection View
Now, you will create the CDS metadata extensions **`ZS_C_BOOK_##`** to enrich the Booking BO projection view with UI semantics.  

1.	Right-click on your Booking BO projection view **`ZS_C_BOOK_##`** in the Project Explorer and choose **New Metadata Extension** from the context menu.  
 
2.	Maintain **`ZS_C_BOOK_##`** as name and a meaningful description (e.g. _UI Annotations for ZS_C_BOOK_##)  and choose **Next >** to continue.  
    Project, Package and Extended Entity are automatically assigned in the creation wizard.  
 
3.	Assign a transport request and choose **Next >**. 
 
4.	Select the annotate view template and choose **Finish**.

5.	Specify **`#CORE`** as metadata layer at the top of the extension.    

6.	Now, you can specify the UI annotations for the remaining elements.  
    For that, replace the code in the editor with the code snippet provided below and replace all occurrences of  `######` with your chosen suffix. 

    <pre>
    @Metadata.layer: #CORE
    @UI: {
      headerInfo: { typeName: 'Booking',
                    typeNamePlural: 'Bookings',
                    title: { type: #STANDARD, value: 'BookingID' } } }

    annotate view ZS_C_BOOK_##
        with 
    {
      @UI.facet: [ { id:            'Booking',
                     purpose:       #STANDARD,
                     type:          #IDENTIFICATION_REFERENCE,
                     label:         'Booking',
                     position:      10 }  ]

      @UI: { identification: [ { position: 10, label: 'Booking UUID'  } ] }
      BookingUUID;

      @UI.hidden: true
      TravelUUID;

      @UI: { lineItem:       [ { position: 20 } ],
             identification: [ { position: 20 } ] }
      BookingID;

      @UI: { lineItem:       [ { position: 30 } ],
             identification: [ { position: 30 } ] }
      BookingDate;

      @UI: { lineItem:       [ { position: 40 } ],
             identification: [ { position: 40 } ] }
      CustomerID;

      @UI: { lineItem:       [ { position: 50 } ],
             identification: [ { position: 50 } ] }
      CarrierID;

      @UI: { lineItem:       [ { position: 60 } ],
             identification: [ { position: 60 } ] }
      ConnectionID;

      @UI: { lineItem:       [ { position: 70 } ],
             identification: [ { position: 70 } ] }
      FlightDate;

      @UI: { lineItem:       [ { position: 80 } ],
             identification: [ { position: 80 } ] }
      FlightPrice;

      @UI.hidden: true
      LocalLastChangedAt;
    }
    </pre>

8.	Save and activate the changes.  

## Publish a Service 
### Step 1. Create the Service Definition
First, create the service definition **`ZS_UI_TRAV_##`** to specify the service scope, i.e. the relevant entity sets to be exposed in the service.

1.	In the Project Explorer, right-click on the Travel BO projection view **`ZS_C_TRAV_##`** and select **New Service Definition** from the context menu.

2.	Maintain **`ZS_UI_TRAV_##`** as name and a meaningful description (e.g. _**`Service Definition for Travel App`**_) in the creation wizard and choose **Next >** to continue.     
    Package and Project have been assigned automatically.  

3.	Assign a transport request and choose **Next >**. 

4.	Select the template **`Define Service`**  and choose **Finish**. 

5.	Now, define the service scope by specifying the CDS view names of the relevant BO entities and associations – e.g. Travel and Booking entities and value help providers for the Agency, Customer, Flight, Carrier entities and the Currency code – and specify a local alias for each of them using the keyword **`as`**. Aliases are optional but ease the service consumption.   
  
    For that, replace the code in the editor with the code snippet provided below. 

    <pre>
    @EndUserText.label: 'Serv Definition for Travel App'
    define service ZUI_RAP_TRAV_#### {
      expose ZS_C_TRAV_## as Travel;
      expose ZS_C_BOOK_## as Booking;
      expose /DMO/I_Agency as Agency;
      expose /DMO/I_Customer as Customer;
      expose /DMO/I_Flight as Flight;
      expose /DMO/I_Carrier as Carrier;
      expose /DMO/I_Connection as Connection;
      expose /DMO/I_Airport as Airport;
      expose I_Currency as Currency;
      expose I_Country as country;
    }
    </pre>
    
6.	Save and activate the service definition.

    
### Step 2. Create the Service Binding
Now, create the service binding **`ZS_UI_TRAV_O2_##`** to bind your service definition to the OData protocol.  

1.	Right-click on the just created service definition **`ZS_UI_TRAV_##`** in the project Explorer and choose **New Service Binding** from the context menu.   

2.	Maintain **`ZS_UI_TRAV_O2_##`**  as name and a meaningful description (e.g. _`OData V2 UI service for SAP Fiori Travel App`_).     Select **`OData V2 - UI`** as Binding Type and choose **Next >** to continue.  
    
3.	Assign a transport request and choose **Finish**.  

4. Save and activate the service binding.	

5. Click on **`Publish`** - or **`Activate`** depending on your ADT version - in the **Service Version Details** area to activate the Local Service Endpoint. This may take few minutes.

# Step 3. Preview Application
Click on the exposed "Travel" entity and select "Preview". A new browser window containing the app preview will be displayed.
