//
//  wjGetPhoneNumber.m
//  获取本机号码
//
//  Created by gouzi on 2017/3/28.
//  Copyright © 2017年 王钧. All rights reserved.
//

#import "wjGetPhoneNumber.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface wjGetPhoneNumber () <CNContactPickerDelegate>

@end

@implementation wjGetPhoneNumber

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getContactBookPhoneNumber];
}

- (void)test  {
    
}


#pragma mark - 无UI界面的
/**
 *  获取通讯录中的所有电话号码
 */
- (void)getContactBookPhoneNumber {
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusAuthorized) {
        NSLog(@"已经授权...");
    } else {
        return;
    }
    
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSLog(@"-------------------------------------------------------");
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
        
        NSString *name = [UIDevice currentDevice].name;
        NSString *phoneName = [familyName stringByAppendingString:givenName];
        NSLog(@"phone name is :%@", phoneName);
        
        NSArray *phoneNumbers = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneNumbers) {
            if ([name isEqualToString:phoneName]) {
                NSString *label = labelValue.label;
                CNPhoneNumber *phoneNumber = labelValue.value;
                NSLog(@"label=%@, phone=%@", label, phoneNumber.stringValue);
                *stop = YES;
            }
        }
        //    *stop = YES; // 停止循环，相当于break；
    }];
}


#pragma mark - 有界面的显示
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (event.type == 0) {
        CNContactPickerViewController *contactPickerVC = [[CNContactPickerViewController alloc] init];
        contactPickerVC.delegate = self;
        [self presentViewController:contactPickerVC animated:YES completion:nil];
    }
}



#pragma mark - delegate
// 选中一个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    NSLog(@"contact is %@", contact);
    for (CNLabeledValue *labelValue in contact.phoneNumbers) {
        CNPhoneNumber *phoneNumber = labelValue.value;
        NSLog(@"number is %@", phoneNumber.stringValue);
    }
}

/*
// 选中一个联系人的属性
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    NSLog(@"contact property is %@", contactProperty);
}

// 选中多个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact *> *)contacts {
    
}

// 选中一个联系人的多个属性
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperties:(NSArray<CNContactProperty *> *)contactProperties {
    
}
*/

@end
