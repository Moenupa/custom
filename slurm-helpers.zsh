# --- useful slurm completion utilities ---
if ! command -v scontrol &> /dev/null; then
	return
fi

_slurm_partitions() {
	local -a partitions
	partitions=( ${(@f)"$(sinfo -h -o '%P' 2>/dev/null)"} )
	_describe 'partition' partitions
}

_slurm_accounts() {
	local -a accounts
	if command -v sacctmgr >/dev/null; then
		accounts=( ${(@f)"$(sacctmgr show account -n -P format=Account 2>/dev/null)"} )
		_describe 'account' accounts
	fi
}

_slurm_qos() {
	local -a qos
	if command -v sacctmgr >/dev/null; then
		qos=( ${(@f)"$(sacctmgr show qos -n -P format=Name 2>/dev/null)"} )
		_describe 'qos' qos
	fi
}

_slurm_reservations() {
	local -a reservations
	reservations=( ${(@f)"$(scontrol show reservation 2>/dev/null | sed -n 's/ReservationName=\\([^ ]*\\).*/\\1/p')"} )
	_describe 'reservation' reservations
}

_slurm_constraints() {
	local -a lines feats
	lines=( ${(@f)"$(sinfo -h -o %f 2>/dev/null)"} )
	local all="${(j:,:)lines}"
	feats=( ${(u)${(s:,:)"$all"} } )
	_describe 'feature' feats
}

_slurm_gres() {
	local -a gres
	gres=( ${(@f)"$(sinfo -h -o %G 2>/dev/null | tr , '\\n' | sed 's/(.*)//' | sed 's/*.*//')" } )
	gres=( ${(u)gres} )
	_describe 'gres' gres
}

_slurm_resources() {
	_values 'resource limit' \
		'ALL' 'AS' 'CORE' 'CPU' 'DATA' 'FSIZE' 'MEMLOCK' 'NOFILE' 'NPROC' 'RSS' 'STACK'
}

_slurm_mpi_types() {
	local -a types
	types=(none pmi2 pmix openmpi)
	_describe 'mpi type' types
}