﻿

// See http://www.gnu.org/licenses/gpl-2.0.. 


namespace EasyUI.Web.Mvc.UI
{
    public class GridClientEvents : IClientSerializable
    {
        public GridClientEvents()
        {
            OnColumnResize = new ClientEvent();
            OnError = new ClientEvent();
            OnDataBinding = new ClientEvent();
            OnDataBound = new ClientEvent();
            OnRowDataBound = new ClientEvent();
            OnLoad = new ClientEvent();
            OnRowSelect = new ClientEvent();
            OnEdit = new ClientEvent();
            OnSave = new ClientEvent();
            OnDelete = new ClientEvent();
            OnDetailViewExpand = new ClientEvent();
            OnDetailViewCollapse = new ClientEvent();
            OnColumnReorder = new ClientEvent();
            OnSubmitChanges = new ClientEvent();
            OnCommand = new ClientEvent();
            OnComplete = new ClientEvent();
        }

        public ClientEvent OnCommand
        {
            get;
            private set;
        }

        public ClientEvent OnDetailViewCollapse
        {
            get;
            private set;
        }        
        
        public ClientEvent OnSubmitChanges
        {
            get;
            private set;
        }
        
        public ClientEvent OnDetailViewExpand
        {
            get;
            private set;
        }

        public ClientEvent OnColumnResize 
        { 
            get; 
            private set; 
        }        
        
        public ClientEvent OnColumnReorder
        { 
            get; 
            private set; 
        }

        public ClientEvent OnDelete
        {
            get;
            private set;
        }

        public ClientEvent OnError 
        { 
            get; 
            private set; 
        }

        public ClientEvent OnDataBinding 
        { 
            get; 
            private set; 
        }

        public ClientEvent OnDataBound 
        { 
            get; 
            private set; 
        }

        public ClientEvent OnRowDataBound 
        { 
            get; 
            private set; 
        }

        public ClientEvent OnLoad 
        { 
            get; 
            private set; 
        }

        public ClientEvent OnRowSelect 
        { 
            get; 
            private set; 
        }

        public ClientEvent OnEdit
        {
            get;
            private set;
        }

        public ClientEvent OnSave
        {
            get;
            private set;
        }

        public ClientEvent OnComplete
        { 
            get;
            private set;
        }

        public void SerializeTo(string key, IClientSideObjectWriter writer)
        {
            writer.AppendClientEvent("onColumnResize", OnColumnResize);
            writer.AppendClientEvent("onColumnReorder", OnColumnReorder);
            writer.AppendClientEvent("onCommand", OnCommand);
            writer.AppendClientEvent("onComplete", OnComplete);
            writer.AppendClientEvent("onDelete", OnDelete);
            writer.AppendClientEvent("onDetailViewCollapse", OnDetailViewCollapse);
            writer.AppendClientEvent("onDetailViewExpand", OnDetailViewExpand);
            writer.AppendClientEvent("onDataBinding", OnDataBinding);
            writer.AppendClientEvent("onDataBound", OnDataBound);
            writer.AppendClientEvent("onEdit", OnEdit);
            writer.AppendClientEvent("onError", OnError);
            writer.AppendClientEvent("onLoad", OnLoad);
            writer.AppendClientEvent("onRowDataBound", OnRowDataBound);
            writer.AppendClientEvent("onRowSelect", OnRowSelect);
            writer.AppendClientEvent("onSave", OnSave);
            writer.AppendClientEvent("onSubmitChanges", OnSubmitChanges);
        }
    }
}