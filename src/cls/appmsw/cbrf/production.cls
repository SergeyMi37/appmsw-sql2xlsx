Class appmsw.cbrf.production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="appmsw.cbrf.production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="appmsw.cbrf.service.ExchangeRates" Category="" ClassName="appmsw.cbrf.service.ExchangeRates" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">86400</Setting>
    <Setting Target="Host" Name="CountDay">10</Setting>
    <Setting Target="Host" Name="StopIfLoaded">1</Setting>
  </Item>
</Production>
}

}

