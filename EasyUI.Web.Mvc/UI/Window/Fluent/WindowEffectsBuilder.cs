﻿// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Fluent
{
    public class WindowEffectsBuilder : EffectsBuilderBase
    {
        private readonly IEffectContainer container;

        public WindowEffectsBuilder(IEffectContainer container) : base(container) 
        {
            this.container = container;
        }

        /// <summary>
        /// Enables zoom animation.
        /// </summary>
        public WindowEffectsBuilder Zoom()
        {
            container.Container.Add(new ZoomAnimation());

            return this;
        }
    }
}
