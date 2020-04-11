global class DataClassification implements TxnSecurity.EventCondition {

    public boolean evaluate(SObject event){
        switch on event {
           when ApiEvent apiEvent {
                return evaluateApiEvent(apiEvent);
           }
           when ReportEvent reportEvent {
                return evaluateReportEvent(reportEvent);
           }
           when null {
               System.debug('null');
               return true;
           }
           when else {
               System.debug('default');
               return true;
           }
        }
    }
    
    public boolean evaluateApiEvent(ApiEvent apiEvent) {
        return hasConfidentialFields(apiEvent.QueriedEntities.toLowerCase(), apiEvent.Query.toLowerCase());
    }
    
    public boolean evaluateReportEvent(ReportEvent reportEvent) {
        return hasConfidentialFields(reportEvent.QueriedEntities.toLowerCase(), reportEvent.ColumnHeaders.toLowerCase());
    }
    
    public boolean hasConfidentialFields(String entities, String fields){
        List<String> confidentialFields = getConfidentialFields(entities);
        
        for(String confidentialField : confidentialFields) {
            if(fields.contains(confidentialField)) {
                return true;
            }
        }
        
        return false;
    }
    
    public List<String> getConfidentialFields(String entity){
        List<FieldDefinition> fieldDefinitions = [
            SELECT DeveloperName, SecurityClassification 
            FROM FieldDefinition 
            WHERE EntityDefinitionId = :entity 
            AND SecurityClassification != null];
        
        List<String> ConfidentialFields = new List<String>();        
        for(FieldDefinition fieldDefinition: fieldDefinitions){
            confidentialFields.add(fieldDefinition.DeveloperName.toLowerCase());
        }
        return confidentialFields;
    }
}