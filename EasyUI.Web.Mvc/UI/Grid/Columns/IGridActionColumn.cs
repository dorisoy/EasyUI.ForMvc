﻿



namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    
    public interface IGridActionColumn : IGridColumn
    {
        IList<IGridActionCommand> Commands 
        { 
            get; 
        }
    }
}
