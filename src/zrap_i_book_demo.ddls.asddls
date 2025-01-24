@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Business Object: Booking'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZRAP_I_BOOK_DEMO
  as select from zrap_book_demo
  association        to parent ZRAP_I_TRAV_DEMO as _Travel     on  $projection.TravelUuid = _Travel.TravelUuid

  association [1..1] to /DMO/I_Customer         as _Customer   on  $projection.CustomerId = _Customer.CustomerID
  association [1..1] to /DMO/I_Carrier          as _Carrier    on  $projection.CarrierId = _Carrier.AirlineID
  association [1..1] to /DMO/I_Connection       as _Connection on  $projection.CarrierId    = _Connection.AirlineID
                                                               and $projection.ConnectionId = _Connection.ConnectionID
  association [1..1] to /DMO/I_Flight           as _Flight     on  $projection.CarrierId    = _Flight.AirlineID
                                                               and $projection.ConnectionId = _Flight.ConnectionID
                                                               and $projection.FlightDate   = _Flight.FlightDate
  association [0..1] to I_Currency              as _Currency   on  $projection.CurrencyCode = _Currency.Currency
{
  key booking_uuid          as BookingUuid,
      travel_uuid           as TravelUuid,
      booking_id            as BookingId,
      booking_date          as BookingDate,
      customer_id           as CustomerId,
      carrier_id            as CarrierId,
      connection_id         as ConnectionId,
      flight_date           as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price          as FlightPrice,
      currency_code         as CurrencyCode,
      created_by            as CreatedBy,
      last_changed_by       as LastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      // Make association public
      _Travel,
      _Customer,
      _Carrier,
      _Flight,
      _Currency,
      // Calculated Fields
       concat_with_space(_Customer.FirstName, _Customer.LastName, 1) as CustomerName
}
      
