




namespace EasyUI.Web.Mvc.Extensions
{
    using System;
    using System.Threading;

    using Infrastructure;

    /// <summary>
    /// Contains extension methods of <see cref="ReaderWriterLockSlim"/>.
    /// </summary>
    public static class ReaderWriterLockSlimExtensions
    {
        /// <summary>
        /// Starts thread safe read write code block.
        /// </summary>
        /// <param name="instance">The instance.</param>
        /// <returns></returns>
        public static IDisposable ReadAndWrite(this ReaderWriterLockSlim instance)
        {
            Guard.IsNotNull(instance, "instance");

            instance.EnterUpgradeableReadLock();

            return new DisposableCodeBlock(instance.ExitUpgradeableReadLock);
        }

        /// <summary>
        /// Starts thread safe read code block.
        /// </summary>
        /// <param name="instance">The instance.</param>
        /// <returns></returns>
        public static IDisposable Read(this ReaderWriterLockSlim instance)
        {
            Guard.IsNotNull(instance, "instance");

            instance.EnterReadLock();

            return new DisposableCodeBlock(instance.ExitReadLock);
        }

        /// <summary>
        /// Starts thread safe write code block.
        /// </summary>
        /// <param name="instance">The instance.</param>
        /// <returns></returns>
        public static IDisposable Write(this ReaderWriterLockSlim instance)
        {
            Guard.IsNotNull(instance, "instance");

            instance.EnterWriteLock();

            return new DisposableCodeBlock(instance.ExitWriteLock);
        }

        private sealed class DisposableCodeBlock : IDisposable
        {
            private readonly Action action;

            public DisposableCodeBlock(Action action)
            {
                this.action = action;
            }

            public void Dispose()
            {
                action();
            }
        }
    }
}