permissionset 50200 ARD_AICampaignPerm
{
    Assignable = true;
    Permissions = tabledata ARD_Campaign=RIMD,
        tabledata ARD_CampaignItem=RIMD,
        tabledata ARD_CampaignPostalCode=RIMD,
        table ARD_Campaign=X,
        table ARD_CampaignItem=X,
        table ARD_CampaignPostalCode=X,
        page ARD_AICampaign=X,
        page ARD_AICampaigns=X,
        page ARD_CampaignItem=X;
}