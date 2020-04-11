global class DataClassificationonsensiEventCondition implements TxnSecurity.EventCondition {
    /***********************************************************
    * BLOCK REPORTS WITH A "CONFIDENTIAL" FIELD.
    ***********************************************************/
    public boolean evaluate(SObject event){
        ReportEvent reportEvent = (ReportEvent) event;
        system.debug('LOGIMNHISTORY******************' + reportEvent.loginHistoryId);
        return hasConfidentialFields(reportEvent.QueriedEntities.toLowerCase(), reportEvent.ColumnHeaders);
    }
    
    public boolean hasConfidentialFields(String entity, String query){
        List<String> confidentialFields = getConfidentialFields('Case');
            
        for(String confidentialField : confidentialFields) {
            if (query.containsIgnoreCase(confidentialField)) {
                return true;
            }
        }
        return false;
    }

    /*******************************************************************************
    * FETCH THE FIELDS THAT ARE MARKED CONFIDENTIAL FROM FIELDDEFINITION ENTITY.
    ******************************************************************************/
    public List<String> getConfidentialFields(String entity) {
        List<FieldDefinition> fieldDefinitions = [
            SELECT DeveloperName, SecurityClassification, durableId 
            FROM FieldDefinition 
            WHERE EntityDefinitionId = :entity
            AND SecurityClassification = 'Confidential'];

        List<String> confidentialFields = new List<String>();        
        for(FieldDefinition fieldDefinition: fieldDefinitions){
            confidentialFields.add(fieldDefinition.DeveloperName.toLowerCase());
        }
        return confidentialFields;
    }
}