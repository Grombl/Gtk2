#!/usr/bin/perl -w

# $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/Gtk2/t/GtkTreeModelIface.t,v 1.2 2004/08/01 02:44:18 muppetman Exp $

package CustomList;

use strict;
use warnings;

use Glib qw(TRUE FALSE);
use Gtk2;

use Test::More;

use Glib::Object::Subclass
	Glib::Object::,
	interfaces => [ Gtk2::TreeModel:: ],
	;

# one-time init:
my %ordmap;
{
my $i = 0;
%ordmap = map { $_ => $i++ } qw(
	First Second Third Fourth Fifth
	Sixth Seventh Eighth Ninth Tenth
	Eleventh Twelfth Thirteenth Fourteenth Fifteenth
	Sixteenth Seventeenth Eighteenth Nineteenth Twentieth
);
}

sub INIT_INSTANCE {
	my ($list) = @_;

	isa_ok ($list, "CustomList", "INIT_INSTANCE");

	$list->{data}  = [];
	
	foreach my $val (sort { $ordmap{$a} <=> $ordmap{$b} } keys %ordmap) {
		my $record = { pos => $ordmap{$val}, value => $val };
		push @{$list->{data}}, $record;
	}
	
	$list->{stamp} = 23;
}

sub FINALIZE_INSTANCE {
	my ($list) = @_;

	isa_ok ($list, "CustomList", "FINALIZE_INSTANCE");
}

sub GET_FLAGS {
	my ($list) = @_;

	isa_ok ($list, "CustomList", "GET_FLAGS");

	return [ qw/list-only iters-persist/ ];
}

sub GET_N_COLUMNS {
	my ($list) = @_;

	isa_ok ($list, "CustomList", "GET_N_COLUMNS");

	# we don't actually have 23 columns, just 1 -- but the point here is
	# to test that the marshaling actually puts through the correct
	# number, not just nonzero.
	return 23;
}

sub GET_COLUMN_TYPE {
	my ($list, $column) = @_;

	isa_ok ($list, "CustomList", "GET_COLUMN_TYPE");
	is ($column, 1, "GET_COLUMN_TYPE");

	return Glib::String::
}

sub GET_ITER {
	my ($list, $path) = @_;

	isa_ok ($list, "CustomList", "GET_ITER");
	isa_ok ($path, "Gtk2::TreePath", "GET_ITER");

	my @indices = $path->get_indices;
	my $depth   = $path->get_depth;

	ok ($depth == 1, "GET_ITER");

	my $n = $indices[0];

	ok ($n < @{$list->{data}}, "GET_ITER");
	ok ($n > 0, "GET_ITER");

	my $record = $list->{data}[$n];

	ok (defined ($record), "GET_ITER");
	ok ($record->{pos} == $n, "GET_ITER");

	return [ $list->{stamp}, $n, $record, undef ];
}

sub GET_PATH {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList", "GET_PATH");
	ok ($iter->[0] == $list->{stamp}, "GET_PATH");

	my $record = $iter->[2];

	my $path = Gtk2::TreePath->new;
	$path->append_index ($record->{pos});

	return $path;
}

sub GET_VALUE {
	my ($list, $iter, $column) = @_;

	isa_ok ($list, "CustomList");
	ok ($iter->[0] == $list->{stamp}, "GET_VALUE");
	
	is ($column, 1, "GET_VALUE");

	my $record = $iter->[2];

	ok (defined ($record), "GET_VALUE");

	ok ($record->{pos} < @{$list->{data}}, "GET_VALUE");
	
	return $record->{value};
}

sub ITER_NEXT {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList", "ITER_NEXT");
	ok ($iter->[0] == $list->{stamp}, "ITER_NEXT");

	ok (defined ($iter->[2]), "ITER_NEXT");

	my $record = $iter->[2];

	# Is this the last record in the list?
	return undef if $record->{pos} >= @{ $list->{data} };

	my $nextrecord = $list->{data}[$record->{pos} + 1];

	ok (defined ($nextrecord), "ITER_NEXT");
	
	ok ($nextrecord->{pos} == ($record->{pos} + 1), "ITER_NEXT");

	return [ $list->{stamp}, $nextrecord->{pos}, $nextrecord, undef ];
}

sub ITER_CHILDREN {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList", "ITER_CHILDREN");

	# this is a list, nodes have no children
	return undef if $iter;

	# parent == NULL is a special case; we need to return the first top-level row

 	# No rows => no first row
	return undef unless @{ $list->{data} };

	# Set iter to first item in list
	return [ $list->{stamp}, 0, $list->{data}[0] ];
}

sub ITER_HAS_CHILD {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList", "ITER_HAS_CHILD");
	ok ($iter->[0] == $list->{stamp}, "ITER_HAS_CHILD");

	return FALSE;
}

sub ITER_N_CHILDREN {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList", "ITER_N_CHILDREN");

	# special case: if iter == NULL, return number of top-level rows
	return scalar @{$list->{data}} if ! $iter;

	return 0; # otherwise, this is easy again for a list
}

sub ITER_NTH_CHILD {
	my ($list, $iter, $n) = @_;

	isa_ok ($list, "CustomList", "ITER_NTH_CHILD");

	# a list has only top-level rows
	return undef if $iter;

	# special case: if parent == NULL, set iter to n-th top-level row

	ok ($n < @{$list->{data}}, "ITER_NTH_CHILD");

	my $record = $list->{data}[$n];

	ok (defined ($record), "ITER_NTH_CHILD");
	ok ($record->{pos} == $n, "ITER_NTH_CHILD");

	return [ $list->{stamp}, $n, $record, undef ];
}

sub ITER_PARENT {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList", "ITER_PARENT");

	return undef;
}

sub REF_NODE {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList", "REF_NODE");
	ok ($iter->[0] == $list->{stamp});
}

sub UNREF_NODE {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList", "UNREF_NODE");
	ok ($iter->[0] == $list->{stamp});
}

sub set {
	my $list     = shift;
	my $treeiter = shift;

	isa_ok ($list, "CustomList", "set");
	isa_ok ($treeiter, "Gtk2::TreeIter", "set");

	my ($col, $value) = @_;
	ok ($col == 1, "set");

	my $iter = $treeiter->to_arrayref($list->{stamp});
	my $record = $iter->[2];

	$record->{value} = $value;
}

sub get_iter_from_ordinal {
	my $list = shift;
	my $ord  = shift;

	isa_ok ($list, "CustomList", "get_iter_from_ordinal");

	my $n = $ordmap{$ord};

	my $record = $list->{data}[$n];

	ok (defined ($record), "get_iter_from_ordinal record is valid");

	my $iter = Gtk2::TreeIter->new_from_arrayref([$list->{stamp}, $n, $record, undef]);

	isa_ok ($iter, "Gtk2::TreeIter", "get_iter_from_ordinal");

	return $iter;
}


###############################################################################

package main;

use Gtk2::TestHelper tests => 92, noinit => 1;
use strict;
use warnings;

my $model = CustomList->new;

is ($model->get_flags, [qw/list-only iters-persist/]);
is ($model->get_n_columns, 23, "get_n_columns reports the number correctly");
is ($model->get_column_type (1), Glib::String::);

my $path = Gtk2::TreePath->new ("5");
my $iter;

isa_ok ($iter = $model->get_iter ($path), "Gtk2::TreeIter");
isa_ok ($path = $model->get_path ($iter), "Gtk2::TreePath");
is_deeply ([$path->get_indices], [5]);

is ($model->get_value ($iter, 1), "Sixth");
is ($model->get ($iter, 1), "Sixth");

isa_ok ($iter = $model->iter_next ($iter), "Gtk2::TreeIter");
isa_ok ($path = $model->get_path ($iter), "Gtk2::TreePath");
is_deeply ([$path->get_indices], [6]);

isa_ok ($iter = $model->iter_children(undef), "Gtk2::TreeIter");
isa_ok ($path = $model->get_path ($iter), "Gtk2::TreePath");
is_deeply ([$path->get_indices], [0]);

is ($model->iter_has_child ($iter), FALSE);
is ($model->iter_n_children ($iter), 0);

isa_ok ($iter = $model->iter_nth_child (undef, 7), "Gtk2::TreeIter");
isa_ok ($path = $model->get_path ($iter), "Gtk2::TreePath");
is_deeply ([$path->get_indices], [7]);

ok (not defined ($model->iter_parent ($iter)));

isa_ok ($iter = $model->get_iter_from_ordinal ('Twelfth'), "Gtk2::TreeIter");
isa_ok ($path = $model->get_path ($iter), "Gtk2::TreePath");
is_deeply ([$path->get_indices], [11]);

$model->set($iter, 1, '12th');
is ($model->get($iter, 1), '12th');

$model->ref_node ($iter);
$model->unref_node ($iter);