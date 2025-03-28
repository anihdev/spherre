#[starknet::contract]
pub mod MockContract {
    use AccountData::InternalTrait;
    use spherre::account_data::AccountData;
    use starknet::ContractAddress;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    component!(path: AccountData, storage: account_data, event: AccountDataEvent);

    #[abi(embed_v0)]
    pub impl AccountDataImpl = AccountData::AccountDataComponent<ContractState>;

    pub impl AccountDataInternalImpl = AccountData::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub account_data: AccountData::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        AccountDataEvent: AccountData::Event,
    }

    fn get_members(self: @ContractState) -> Array<ContractAddress> {
        let members = self.account_data.get_account_members();
        members
    }

    fn get_members_count(self: @ContractState) -> u64 {
        self.account_data.members_count.read()
    }

    #[generate_trait]
    pub impl PrivateImpl of PrivateTrait {
        fn set_threshold(ref self: ContractState, val: u64) {
            self.account_data.set_threshold(val);
        }
        fn get_threshold(self: @ContractState) -> (u64, u64) {
            self.account_data.get_threshold()
        }
        fn edit_member_count(ref self: ContractState, val: u64) {
            self.account_data.members_count.write(val);
        }
    }
}
