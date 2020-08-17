namespace EasyUI.MSBuildTasks
{
    using Microsoft.Build.Framework;
    using Microsoft.Build.Utilities;
    using System;
    using System.Runtime.CompilerServices;
    using System.Text;
    using System.Xml;
    using System.Xml.XPath;

    public class MultiXmlUpdate : Task
    {
        private bool _enableLogging = true;
        private bool _saveFile = true;

        private void DeleteNodes()
        {
            foreach (XmlNode node in this.XmlDocument.SelectNodes(this.XPath))
            {
                node.ParentNode.RemoveChild(node);
            }
        }

        public override bool Execute()
        {
            try
            {
                if (this.XmlDocument == null)
                {
                    this.XmlDocument = new System.Xml.XmlDocument();
                    this.XmlDocument.Load(this.XmlFileName);
                }
                XPathNavigator navigator = this.XmlDocument.CreateNavigator();
                XmlNamespaceManager nsResolver = new XmlNamespaceManager(navigator.NameTable);
                if (!string.IsNullOrEmpty(this.Prefix) && !string.IsNullOrEmpty(this.Namespace))
                {
                    nsResolver.AddNamespace(this.Prefix, this.Namespace);
                }
                XPathExpression expr = XPathExpression.Compile(this.XPath, nsResolver);
                XPathNodeIterator iterator = navigator.Select(expr);
                if (this.EnableLogging)
                {
                    base.Log.LogMessage("Nodes to update:", new object[] { iterator.Count });
                }
                if (this.Delete)
                {
                    this.DeleteNodes();
                }
                else
                {
                    this.ReplaceNodeValues(iterator);
                }
                if (this.SaveFile)
                {
                    using (XmlTextWriter writer = new XmlTextWriter(this.XmlFileName, Encoding.UTF8))
                    {
                        writer.Formatting = Formatting.Indented;
                        this.XmlDocument.Save(writer);
                        writer.Close();
                    }
                }
            }
            catch (Exception exception)
            {
                if (this.EnableLogging)
                {
                    base.Log.LogErrorFromException(exception);
                }
                return false;
            }
            return true;
        }

        private void ReplaceNodeValues(XPathNodeIterator iterator)
        {
            while (iterator.MoveNext())
            {
                if (this.Value != null)
                {
                    iterator.Current.SetValue(this.Value);
                }
            }
        }

        public bool Delete { get; set; }

        internal bool EnableLogging
        {
            get
            {
                return this._enableLogging;
            }
            set
            {
                this._enableLogging = value;
            }
        }

        public string Namespace { get; set; }

        public string Prefix { get; set; }

        internal bool SaveFile
        {
            get
            {
                return this._saveFile;
            }
            set
            {
                this._saveFile = value;
            }
        }

        public string Value { get; set; }

        internal System.Xml.XmlDocument XmlDocument { get; set; }

        [Required]
        public string XmlFileName { get; set; }

        [Required]
        public string XPath { get; set; }
    }
}

