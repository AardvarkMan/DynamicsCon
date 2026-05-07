namespace AardvarkLabs.AgentDemo;

using System.Agents;

enumextension 60001 ARD_CashFlowAgentMDProvider extends "Agent Metadata Provider"
{
    
    value(60000; "Cash Flow Agent")
    {
        Caption = 'Cash Flow Agent';
        Implementation = IAgentfactory = Ard_CashFlowAgentFactory, IAgentMetadata = Ard_CashFlowAgentMetadata;
    }
}
