#include <linux/init.h>
#include <linux/module.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/kernel.h>

static int func_dummy_show(struct seq_file *m, void *v)
{
	return 0;
}

static int func_dummy_open(struct inode *inode, struct file *file)
{
	return single_open(file, func_dummy_show, NULL);
}

static ssize_t func_dummy_write(struct file *file,
		const char __user *buf, size_t count, loff_t *pos)
{
	return count;
}

static const struct file_operations os3_dummy_fops = {
	.owner = THIS_MODULE,
	.open = func_dummy_open,
	.read = seq_read,
	.write = func_dummy_write,
	.llseek = seq_lseek,
	.release = single_release,
};

static int __init moon_func_os3_init(void)
{
	proc_mkdir("mi_kernel", NULL);
	proc_mkdir("frame_load", NULL);
	proc_mkdir("io_monitor", NULL);
	proc_mkdir("iorap_node", NULL);
	proc_mkdir("mi_enhance", NULL);

	/* create mi_kernel procfs */
	proc_mkdir("mi_kernel/trace_sched", NULL);
	proc_mkdir("mi_kernel/trace_locking", NULL);
	proc_mkdir("mi_kernel/trace_binder", NULL);
	proc_mkdir("mi_kernel/trace_sys_cost", NULL);
	proc_mkdir("mi_kernel/trace_cpufreq", NULL);

	proc_create("mi_kernel/trace_sched/enable", 0666, NULL, &os3_dummy_fops);
	proc_create("mi_kernel/trace_locking/enable", 0666, NULL, &os3_dummy_fops);
	proc_create("mi_kernel/trace_binder/enable", 0666, NULL, &os3_dummy_fops);
	proc_create("mi_kernel/trace_sys_cost/enable", 0666, NULL, &os3_dummy_fops);
	proc_create("mi_kernel/trace_cpufreq/enable", 0666, NULL, &os3_dummy_fops);

	/* create frame_load procfs */
	proc_mkdir("frame_load/group", NULL);
	proc_create("frame_load/group/all_group", 0666, NULL, &os3_dummy_fops);

	/* create io_monitor procfs */
	proc_mkdir("io_monitor/block", NULL);
	proc_mkdir("io_monitor/iostat", NULL);

	proc_create("io_monitor/enable", 0666, NULL, &os3_dummy_fops);
	proc_create("io_monitor/block/block_enabled", 0666, NULL, &os3_dummy_fops);
	proc_create("io_monitor/iostat/iostat_enabled", 0666, NULL, &os3_dummy_fops);
	proc_create("io_monitor/debug_enable", 0666, NULL, &os3_dummy_fops);

	/* create iorap_node procfs */
	proc_create("iorap_node/colllect", 0666, NULL, &os3_dummy_fops);
	proc_create("iorap_node/hot_collect", 0666, NULL, &os3_dummy_fops);

	/* create mi_enhance procfs */
	proc_create("mi_enhance/swappiness", 0666, NULL, &os3_dummy_fops);

	return 0;
}

module_init(moon_func_os3_init);
